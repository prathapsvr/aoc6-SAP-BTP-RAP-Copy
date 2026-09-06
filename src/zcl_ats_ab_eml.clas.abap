CLASS zcl_ats_ab_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    data : lv_opr type c value 'D'.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ats_ab_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    case lv_opr.
        when 'R'.
            READ ENTITIES OF ZATS_AB_M_TRAVEL in local mode
                ENTITY Travel
                fields ( travelid begindate agencyid customerid overallstatus )
                with VALUE #(
                                ( travelid = '00000010' )
                                ( travelid = '00000024' )
                                ( travelid = '52500024' )
                )

                RESULT data(lt_result)
                FAILED data(lt_failed)
                REPORTED data(lt_report).

            out->write(
              EXPORTING
                data   = lt_result
            ).

            out->write(
              EXPORTING
                data   = lt_failed
            ).

            out->write(
              EXPORTING
                data   = lt_report
            ).
        when 'C'.

           data(lv_descr)  = 'Anubhav Rocks with RAP'.
           data(lv_agency) = '070016'.
           data(lv_customer) = '000697'.

           MODIFY ENTITIES OF ZATS_AB_M_TRAVEL
            ENTITY Travel
            CREATE FIELDS ( Travelid AgencyId CustomerId CurrencyCode BeginDate EndDate
            Description OverallStatus )
            WITH VALUE #(
                            (
                                %CID = 'ANUBHAV'
                                Travelid = '00012347'
                                AgencyId = lv_agency
                                CustomerId = lv_customer
                                CurrencyCode = 'USD'
                                BeginDate = cl_abap_context_info=>get_system_date(  )
                                EndDate = cl_abap_context_info=>get_system_date(  ) + 30
                                Description = lv_descr
                                OverallStatus = 'O'
                            )
                            (
                                %CID = 'ANUBHAV-1'
                                Travelid = '00012348'
                                AgencyId = lv_agency
                                CustomerId = lv_customer
                                CurrencyCode = 'USD'
                                BeginDate = cl_abap_context_info=>get_system_date(  )
                                EndDate = cl_abap_context_info=>get_system_date(  ) + 30
                                Description = lv_descr
                                OverallStatus = 'O'
                            )
                            (
                                %CID = 'ANUBHAV-3'
                                Travelid = '00000010'
                                AgencyId = lv_agency
                                CustomerId = lv_customer
                                CurrencyCode = 'USD'
                                BeginDate = cl_abap_context_info=>get_system_date(  )
                                EndDate = cl_abap_context_info=>get_system_date(  ) + 30
                                Description = lv_descr
                                OverallStatus = 'O'
                            )
                        )
                mapped data(lt_mapped)
                failed lt_failed
                reported lt_report.

            out->write(
              EXPORTING
                data   = lt_mapped
            ).

            out->write(
              EXPORTING
                data   = lt_failed
            ).

            out->write(
              EXPORTING
                data   = lt_report
            ).

            COMMIT ENTITIES.

        when 'U'.

           lv_agency = '070018'.
           lv_descr = 'K K K Kiran'.

           MODIFY ENTITIES OF ZATS_AB_M_TRAVEL
            ENTITY Travel
            UPDATE FIELDS (  AgencyId
            Description  )
            WITH VALUE #(
                            (
                                Travelid = '00012347'
                                AgencyId = lv_agency
                                Description = lv_descr
                            )
                            (
                                Travelid = '00012348'
                                AgencyId = lv_agency
                                Description = lv_descr
                            )
                        )
                mapped lt_mapped
                failed lt_failed
                reported lt_report.

            out->write(
              EXPORTING
                data   = lt_mapped
            ).

            out->write(
              EXPORTING
                data   = lt_failed
            ).

            out->write(
              EXPORTING
                data   = lt_report
            ).

            COMMIT ENTITIES.


        when 'D'.

            MODIFY ENTITIES OF ZATS_AB_M_TRAVEL
            ENTITY Travel
            DELETE FROM
            VALUE #(
                            (
                                Travelid = '00012347'
                            )
                            (
                                Travelid = '00012348'
                            )
                        )
                mapped lt_mapped
                failed lt_failed
                reported lt_report.

            out->write(
              EXPORTING
                data   = lt_mapped
            ).

            out->write(
              EXPORTING
                data   = lt_failed
            ).

            out->write(
              EXPORTING
                data   = lt_report
            ).

            COMMIT ENTITIES.

    endCASE.

  ENDMETHOD.
ENDCLASS.
