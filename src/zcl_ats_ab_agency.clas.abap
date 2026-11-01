CLASS zcl_ats_ab_agency DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.

CLASS zcl_ats_ab_agency IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    DATA: lt_business_data TYPE TABLE OF zats_ab_agencies=>tys_ztravel_agency_ab_type,
          lt_result        TYPE STANDARD TABLE OF zats_ab_cagency WITH EMPTY KEY,
          lt_orderby       TYPE /iwbep/if_cp_runtime_types=>ty_t_sort_order,
          lo_filter_root   TYPE REF TO /iwbep/if_cp_filter_node,
          lo_http_client   TYPE REF TO if_web_http_client,
          lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
          lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
          lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url(
                                 i_url = 'http://s4hana10.saraswatitechnologies.in:8010' ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        lo_http_client->get_http_request( )->set_authorization_basic(
          i_username = 'YOUR_USER'          " <-- replace with real values
          i_password = 'YOUR_PASSWORD' ).

        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                              proxy_model_id      = 'ZATS_AB_AGENCIES'
                                              proxy_model_version = '0001' )
          io_http_client           = lo_http_client
          iv_relative_service_root = '/sap/opu/odata/sap/ZTRAVEL_AGENCY_AB_CDS/' ).

        lo_request = lo_client_proxy->create_resource_for_entity_set( 'ZTRAVEL_AGENCY_AB' )->create_request_for_read( ).

        " ---------- Paging ----------
        IF io_request->is_data_requested( ).
          DATA(lv_top)  = io_request->get_paging( )->get_page_size( ).
          DATA(lv_skip) = io_request->get_paging( )->get_offset( ).
          IF lv_top > 0.
            lo_request->set_top( CONV i( lv_top ) ).
          ENDIF.
          lo_request->set_skip( CONV i( lv_skip ) ).
        ENDIF.

        " ---------- Count ----------
        IF io_request->is_total_numb_of_rec_requested( ).
          lo_request->request_count( ).
        ENDIF.

        " ---------- Sorting (entity names = proxy ABAP names now) ----------
        LOOP AT io_request->get_sort_elements( ) INTO DATA(ls_sort).
          APPEND VALUE #( property_path = ls_sort-element_name
                          descending    = ls_sort-descending ) TO lt_orderby.
        ENDLOOP.
        IF lt_orderby IS NOT INITIAL.
          lo_request->set_orderby( lt_orderby ).
        ENDIF.

        " ---------- Filtering ----------
        TRY.
            DATA(lt_ranges) = io_request->get_filter( )->get_as_ranges( ).
          CATCH cx_rap_query_filter_no_range.
            CLEAR lt_ranges.
        ENDTRY.

        IF lt_ranges IS NOT INITIAL.
          DATA(lo_filter_factory) = lo_request->create_filter_factory( ).
          LOOP AT lt_ranges INTO DATA(ls_range).
            DATA(lo_node) = lo_filter_factory->create_by_range(
                              iv_property_path = ls_range-name
                              it_range         = ls_range-range ).
            lo_filter_root = COND #( WHEN lo_filter_root IS NOT BOUND THEN lo_node
                                     ELSE lo_filter_root->and( lo_node ) ).
          ENDLOOP.
          lo_request->set_filter( lo_filter_root ).
        ENDIF.

        " ---------- Search (acknowledged, not forwarded - V2 has no $search) ----------
        DATA(lv_search) = io_request->get_search_expression( ).

        " ---------- Execute ----------
        lo_response = lo_request->execute( ).

        IF io_request->is_data_requested( ).
          lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).
          lt_result = CORRESPONDING #( lt_business_data ).   " names match 1:1 now
          io_response->set_data( lt_result ).
        ENDIF.

        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lo_response->get_count( ) ).
        ENDIF.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        RAISE SHORTDUMP lx_remote.
      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        RAISE SHORTDUMP lx_gateway.
      CATCH cx_web_http_client_error cx_http_dest_provider_error INTO DATA(lx_http).
        RAISE SHORTDUMP lx_http.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
