CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR Travel RESULT result.
    METHODS copytravel FOR MODIFY
      keys FOR ACTION travel~copytravel.
    METHODS earlynumbering_cba_Booking FOR NUMBERING
      entities FOR CREATE Travel\_Booking.
    METHODS earlynumbering_create FOR NUMBERING
      entities FOR CREATE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD get_global_authorizations.

  ENDMETHOD.

  METHOD earlynumbering_create.

    "Step 1: Data type declaration
    data: entity type strUCTURE FOR create zats_ab_m_travel\\Travel,
          travel_id_max type /dmo/travel_id.


    "Step 2: Ensure that the travel id is not set for any of the record
    loop at entities into entity where travelid is not initial.
        append corrESPONDING #( entity ) to mapped-travel.
    endloop.

    "Step 3: keep the records where travel id is blank - i as a dev take control to generate id
    data(entities_wo_travelid) = entities.
    delete entities_wo_travelid where travelid is not initial.

    "Step 4: get the sequence no from snro --> starring seq no, how many no. 2002 -- 3 numbers
    try.
      "Ctrl+Space and SHift+Enter
      cl_numberrange_runtime=>number_get(
        EXPORTING
          nr_range_nr       = '01'
          object            = conv #( '/DMO/TRAVL' )
          quantity          = CONV #( LINES( entities_wo_travelid ) )
        IMPORTING
          number            = data(number_Range_key)
          returncode        = data(number_range_return_code)
          returned_quantity = data(number_range_return_quantity)
      ).
      CATCH cx_nr_object_not_found into data(lx_not_found).
        loop at entities_wo_travelid into entity.
            append value #( %cid = entity-%cid %key = entity-%key %msg = lx_not_found ) to reported-travel.
            append value #( %cid = entity-%cid %key = entity-%key ) to failed-travel.
        endloop.
      CATCH cx_number_ranges into data(lx_number_range).
        loop at entities_wo_travelid into entity.
            append value #( %cid = entity-%cid %key = entity-%key %msg = lx_number_range ) to reported-travel.
            append value #( %cid = entity-%cid %key = entity-%key ) to failed-travel.
        endloop.
    endtry.


    ""EXTRA BONUS : YOU CAN IGNORE WHILE YOU WORKING - Edge Cases
    case number_range_return_code.
        when '1'.
            ""When number range exceeded a critical threshold
            loop at entities_wo_travelid into entity.
                append value #( %cid = entity-%cid %key = entity-%key
                                %msg = new /dmo/cm_flight_messages(
                                                                   textid = /dmo/cm_flight_messages=>number_range_depleted
                                                                   severity = if_abap_behv_message=>severity-warning
                                                                 )
                                 )
                               to reported-travel.

            endloop.
        when '2' or '3'.
            loop at entities_wo_travelid into entity.
                append value #( %cid = entity-%cid %key = entity-%key
                                %msg = new /dmo/cm_flight_messages(
                                                                   textid = /dmo/cm_flight_messages=>not_sufficient_numbers
                                                                   severity = if_abap_behv_message=>severity-error
                                                                 )
                                 )
                               to reported-travel.
                append value #( %cid = entity-%cid %key = entity-%key
                                %fail-cause = if_abap_behv=>cause-conflict
                                )
                               to failed-travel.
            endloop.

    endCASE.

    ""Step 5 : count the records loop the data and assign number range by incrementing one every time
    assert number_range_return_quantity = lines( entities_wo_travelid ).

    travel_id_max = number_range_key - number_range_return_quantity.

    loop at entities_wo_travelid into entity.

        travel_id_max += 1.
        entity-TravelId = travel_id_max.

        append value #( %cid = entity-%cid %key = entity-%key ) to mapped-travel.

    endLOOP.



  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    "Step 1: define variable to get max booking id for given travel
    data max_booking_id type /dmo/booking_id.

    "Step 2: Use select query to get the bookings which are already added to travel
*    loop at entities into data(entity).
*        SELECT max( booking_id  ) from /dmo/booking_m where travel_id = ..
*    endloop. ---problemetic - calling a non released object / array operation to fetch booking of every travel
     READ ENTITIES OF ZATS_AB_M_TRAVEL IN LOCAL MODE
        entity travel by \_Booking
        FROM CORRESPONDING #( entities )
        link data(lt_bookings).

    ""Loop at travel records and assign booking id inside each travel
    loop at entities assigning field-sYMBOL(<travel_group>) group by <travel_group>-TravelId.

        ""Get the highest booking number for booking in this travel request
        loop at lt_bookings into data(ls_booking) using key entity
                                                  where source-TravelId = <travel_group>-TravelId.
            if max_booking_id < ls_booking-target-BookingId.
                max_booking_id = ls_booking-target-BookingId.
            endif.
        endloop.

        "Get the assigned booking number from incoming request
        loop at entities into data(ls_entity) using key entity
                                    where travelid = <travel_group>-TravelId.
             loop at ls_entity-%target into data(ls_target).
                if max_booking_id < ls_target-BookingId.
                    max_booking_id = ls_target-BookingId.
                endif.
             endloop.
        endloop.

        "Loop at entities over all entries and assign a incremented booking id by 10
        loop at entities assIGNING fiELD-SYMBOL(<travel>) using key entity
                                    where travelid = <travel_group>-TravelId.
             loop at <travel>-%target assIGNING fiELD-SYMBOL(<booking_wo_numbers>).
                append corRESPONDING #( <booking_wo_numbers> ) to mapped-booking
                                                assIGNING fiELD-SYMBOL(<mapped_booking>).
                if <mapped_booking>-BookingId is initial.
                    max_booking_id += 10.
                    <mapped_booking>-BookingId = max_booking_id.
                endif.
             endloop.
        endloop.

    endloop.


  ENDMETHOD.

  METHOD get_instance_features.

    ""My manager asked to disable creation of further bookings inside a travel request which is Rejected.

    ""Step 1: Read the data using EML
    READ ENTITIES OF zats_ab_m_travel in local mode
        entity travel
            fields ( travelid OverallStatus )
            with corRESPONDING #(   keys )
            result data(lt_travels)
            failed failed.

    ""Step 2: return the result with booking creation is possible or not
    read table lt_travels into data(ls_travel) index 1.

    ""Step 3: determine if the status is rejected
     if ( ls_travel-OverallStatus = 'X' ).
        data(lv_allow) = if_abap_behv=>fc-o-disabled.
     else.
        lv_allow = if_abap_behv=>fc-o-enabled.
     endif.

     result = value #( for travel in lt_travels (
                            %tky = travel-%tky
                            %assoc-_Booking = lv_allow
                         ) ).



  ENDMETHOD.

  METHOD copyTravel.

    ""Step 1: declare new itab where we store data to be created
    data : travels          type table for create zats_ab_m_travel\\Travel,
           bookings_cba     type table for create zats_ab_m_travel\\Travel\_Booking,
           booksuppl_cba    type table for create zats_ab_m_travel\\Booking\_BookSuppl.

    ""Step 2: remove the travel instances with initial %cid
    read table keys with key %cid = '' into data(key_with_initial_cid).
    assert key_with_initial_cid is initIAL.

    ""Step 3: Read all the travel data for incoming travel id
    read entities of zats_ab_m_travel in local mode
        entity travel
            all fields with corrESPONDING #( keys )
            result data(lt_travel)
            failed failed.

    read entities of zats_ab_m_travel in local mode
        entity travel by \_Booking
            all fields with corrESPONDING #( lt_travel )
            result data(lt_booking)
            failed failed.

    read entities of zats_ab_m_travel in local mode
        entity booking by \_BookSuppl
            all fields with corrESPONDING #( lt_booking )
            result data(lt_booksuppl)
            failed failed.

    ""Step 4: loop at the actual data and prepare our table for create new travel req
    loop at lt_travel assIGNING fiELD-SYMBOL(<travel>).

        append value #( %cid = keys[ %tky = <travel>-%tky ]-%cid
                        %data = corrESPONDING #( <travel> except travelid )
        ) to travels assIGNING fIELD-SYMBOL(<new_travel>).

        <new_travel>-BeginDate = cl_abap_Context_info=>get_system_date( ).
        <new_travel>-EndDate = cl_abap_Context_info=>get_system_date( ) + 5.
        <new_travel>-OverallStatus = 'O'.

        ""Step 4.1 Fill the booking internal table for data creation - deep copy
        append value #( %cid_ref =  keys[ %tky = <travel>-%tky ]-%cid
                        ) to bookings_cba assIGNING fiELD-SYMBOL(<bookings_cba>).

        loop at lt_booking assIGNING fiELD-SYMBOL(<booking>) where travelid = <travel>-TravelId.

            append value #( %cid = keys[ %tky = <travel>-%tky ]-%cid && <booking>-BookingId
                            %data = corrESPONDING #( lt_booking[ key entity %tky = <booking>-%tky ] except travelid )
                          ) to <bookings_cba>-%target assIGNING fiELD-SYMBOL(<new_booking>).

            <new_booking>-BookingStatus = 'N'.


            append value #( %cid_ref = keys[ %tky = <travel>-%tky ]-%cid && <booking>-BookingId )
                            to booksuppl_cba assIGNING fiELD-SYMBOL(<booksuppl_cba>).

            ""Step 4.2 : fill the supplement data
            loop at lt_booksuppl assIGNING fiELD-SYMBOL(<booksuppl>)
                                        using key entity where
                                                    travelid = <travel>-TravelId and
                                                    bookingid = <booking>-bookingid.
                append value #( %cid = keys[ %tky = <travel>-%tky ]-%cid && <booking>-BookingId && <booksuppl>-BookingSupplementId
                                %data = corrESPONDING #( <booksuppl> exCEPT travelid bookingid )
                            ) to <booksuppl_cba>-%target.

            endloop.

        endloop.



    endLOOP.

    ""Step 5: fire EML to create new data in db
    modIFY entities of zats_ab_m_travel in local mode
        entity travel
            create fields ( agencyid customerid begindate enddate bookingfee totalprice currencycode overallstatus )
                with travels
            create by \_Booking fields ( bookingid bookingdate customerid carrierid connectionid flightdate
                                         flightprice currencycode bookingstatus )
                with bookings_cba
                    entity booking
                        create by \_BookSuppl fields ( bookingsupplementid supplementid price currencycode )
                            with booksuppl_cba
            mapped data(mapped_create).


    mapped-travel = mapped_create-travel.


  ENDMETHOD.

ENDCLASS.




















