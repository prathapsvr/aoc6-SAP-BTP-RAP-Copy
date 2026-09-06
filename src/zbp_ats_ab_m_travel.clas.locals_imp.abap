CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Travel RESULT result.
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

ENDCLASS.




















