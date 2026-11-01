CLASS zcl_CS_agency DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_CS_agency IMPLEMENTATION.


  METHOD if_rap_query_provider~select.


    DATA:
      lt_business_data TYPE TABLE OF zcl_test_ab_agency=>tys_ztravel_agency_ab_type,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

        DATA(top)     = io_request->get_paging( )->get_page_size( ).
        DATA(skip)    = io_request->get_paging( )->get_offset( ).
        DATA(requested_fields)  = io_request->get_requested_elements( ).
        DATA(sort_order)    = io_request->get_sort_elements( ).


         TRY.
         " Create http client
*         DATA(lv_http_destination) = cl_http_destination_provider=>create_by_cloud_destination(
*                                       i_name                  = 'S4HANA2'
*                                       i_service_instance_name = 'mydest'
*                                       i_authn_mode            = if_a4c_cp_service=>service_specific
*                                     )
*                                     .
         DATA(lv_http_destination) = cl_http_destination_provider=>create_by_url( i_url = 'http://s4hana10.saraswatitechnologies.in:8010' ).


         lo_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = lv_http_destination ).

     ""Non Productive BTP Accounts, we need to pass hardcoceed auth data
*         lo_http_client->get_http_request( )->set_header_field(
*                          i_name  = 'Authorization'
*                          i_value = |Basic BASE64_USER:PASS| ).

         lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
                             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                                  proxy_model_id      = 'ZATS_AB_AGENCY'
                                                                  proxy_model_version = '0001' )
                             io_http_client           = lo_http_client
                             iv_relative_service_root = '/sap/opu/odata/sap/ZTRAVEL_AGENCY_AB_CDS/'
*                             iv_do_fetch_csrf_token   = abap_true
                           ).

         ASSERT lo_http_client IS BOUND.




    " Navigate to the resource and create a request for the read operation
    lo_request = lo_client_proxy->create_resource_for_entity_set( 'ztravel_agency_ab' )->create_request_for_read( ).

      IF io_request->is_data_requested( ) = abap_true.
        lo_request->set_skip( CONV i( skip ) ).
        IF top > 0 .
          lo_request->set_top( CONV i( top ) ).
        ENDIF.
      ENDIF.

      IF io_request->is_total_numb_of_rec_requested(  ) = abap_true.
        lo_request->request_count(  ).
      ENDIF.

    lo_request->set_top( 50 )->set_skip( 0 ).

    " Execute the request and retrieve the business data
    lo_response = lo_request->execute( ).
    lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records(  lo_response->get_count(  ) ).
    ENDIF.

    IF io_request->is_data_requested(  ).
      io_response->set_data( lt_business_data ).
    ENDIF.

      CATCH cx_http_dest_provider_error INTO DATA(lx_dest_error).
    " ❌ Destination error - most likely issue
    data(ldls) = lx_dest_error->get_longtext( )..
    RAISE EXCEPTION lx_dest_error.

  CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
    " ❌ Remote OData service error
    data(lv1) = lx_remote->get_longtext( ).

  CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
    " ❌ Gateway error
    data(lv2) = lx_remote->get_longtext( ).

  CATCH cx_web_http_client_error INTO DATA(lx_http_error).
    " ❌ HTTP client error
    data(lv23) = lx_remote->get_longtext( ).

    RAISE EXCEPTION lx_http_error.

  CATCH cx_root INTO data(lx_exception).
    " ❌ Unexpected error
    data(lv4) = lx_exception->get_longtext( ).

  ENDTRY.




  ENDMETHOD.
ENDCLASS.
