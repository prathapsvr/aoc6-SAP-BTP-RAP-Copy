CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    types: tt_travel_failed   type table for failed ZATS_AB_TRAVEL_U,
           tt_travel_reported type table for reported ZATS_AB_TRAVEL_U.

    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR Travel RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS create FOR MODIFY
       entities FOR CREATE Travel.

    METHODS update FOR MODIFY
       entities FOR UPDATE Travel.

    METHODS delete FOR MODIFY
       keys FOR DELETE Travel.

    METHODS read FOR READ
       keys FOR READ Travel RESULT result.

    METHODS lock FOR LOCK
       keys FOR LOCK Travel.

    METHODS set_booked_status FOR MODIFY
       keys FOR ACTION Travel~set_booked_status RESULT result.

*    Map the classic abap t100 messages to what RAP format understand
    METHODS map_messages
        IMPORTING
            cid type string optional
            travel_id type /dmo/travel_id optional
            messages type /dmo/t_message
        EXPORTING
            failed_Added TYPE abap_bool
        changing
            failed type tt_travel_failed
            reported type tt_travel_reported.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

    "Step 1: Data Declaration
    data : messages type /dmo/t_message,
           travel_in type /dmo/travel,
           travel_out type /dmo/travel.

    "loop over incoming data from Fiori app / from EML
    loop AT entities ASSIGNING FIELD-SYMBOL(<travel_Create>).
        "Step 2: get the incoming data in a structure which legacy code understand
        travel_in = corresponding #( <travel_Create> mapping from entity using control ).

        "Step 3: Call legacy code in abap (old code) to set data to tx buffer
        /dmo/cl_flight_legacy=>get_instance( )->create_travel(
          EXPORTING
            is_travel             = corresponding /dmo/s_travel_in( travel_in )
*            it_booking            =
*            it_booking_supplement =
*            iv_numbering_mode     = /dmo/if_flight_legacy=>numbering_mode-early
          IMPORTING
            es_travel             = travel_out
            et_messages           = data(lt_messages)
        ).

        "Step 4: Inform RAP about all the messages and errors
        /dmo/cl_flight_legacy=>get_instance( )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).

        "Step 5: Map the messages to RAP output
        map_messages(
          EXPORTING
            cid          = <travel_Create>-%cid
            travel_id    = <travel_Create>-TravelId
            messages     = messages
          IMPORTING
            failed_added = data(data_failed)
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

        if data_failed = abap_false.

            insert value #( %cid = <travel_Create>-%cid  travelid = <travel_Create>-TravelId
            ) into table mapped-travel.

        endif.

    endloop.



  ENDMETHOD.

  METHOD update.

       "Step 1: Data Declaration
    data : messages type /dmo/t_message,
           travel_in type /dmo/travel,
           travel_u type /dmo/s_travel_inx.

    "loop over incoming data from Fiori app / from EML
    loop AT entities ASSIGNING FIELD-SYMBOL(<travel_update>).
        "Step 2: get the incoming data in a structure which legacy code understand
        travel_in = corresponding #( <travel_update> mapping from entity using control ).
        travel_u-travel_id = <travel_update>-TravelId.
        travel_u-_intx = corresponding #( <travel_update> mapping from entity ).

        "Step 3: Call legacy code in abap (old code) to set data to tx buffer
        /dmo/cl_flight_legacy=>get_instance( )->update_travel(
          EXPORTING
            is_travel              = corresponding /dmo/s_travel_in( travel_in )
            is_travelx             = travel_u
          IMPORTING
             et_messages            = data(lt_messages)
        ).

        "Step 4: Inform RAP about all the messages and errors
        /dmo/cl_flight_legacy=>get_instance( )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).

        "Step 5: Map the messages to RAP output
        map_messages(
          EXPORTING
            cid          = <travel_update>-%cid_ref
            travel_id    = <travel_update>-TravelId
            messages     = messages
          IMPORTING
            failed_added = data(data_failed)
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

    endloop.

  ENDMETHOD.

  METHOD delete.

    data : messages type /dmo/t_message.

    loop at keys ASSIGNING FIELD-SYMBOL(<travel_delete>).

        /dmo/cl_flight_legacy=>get_instance( )->delete_travel(
          EXPORTING
            iv_travel_id = <travel_delete>-TravelId
          IMPORTING
            et_messages  = data(lt_messages)
        ).

                "Step 4: Inform RAP about all the messages and errors
        /dmo/cl_flight_legacy=>get_instance( )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).

        "Step 5: Map the messages to RAP output
        map_messages(
          EXPORTING
            cid          = <travel_delete>-%cid_ref
            travel_id    = <travel_delete>-TravelId
            messages     = messages
          IMPORTING
            failed_added = data(data_failed)
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

    ENDLOOP.


  ENDMETHOD.

  METHOD read.

    data : travel_out type /dmo/travel,
           messages type /dmo/t_message,
           lv_failed type abap_boolean.

    loop at keys ASSIGNING FIELD-SYMBOL(<travel_to_read>) GROUP BY <travel_to_read>-TravelId.

        /dmo/cl_flight_legacy=>get_instance( )->get_travel(
          EXPORTING
            iv_travel_id           = <travel_to_read>-TravelId
            iv_include_buffer      = abap_false
          IMPORTING
             es_travel              =  travel_out
             et_messages            = data(lt_messages)
        ).


                        "Step 4: Inform RAP about all the messages and errors
        /dmo/cl_flight_legacy=>get_instance( )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).

        "Step 5: Map the messages to RAP output
        map_messages(
          EXPORTING
            travel_id    = <travel_to_read>-TravelId
            messages     = messages
          IMPORTING
            failed_added = data(data_failed)
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

        if data_failed = abap_false.

            insert CORRESPONDING #( travel_out mapping to entity ) into table result.

        endif.

    ENDLOOP.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD set_booked_status.

      DATA : messages type /dmo/t_message,
             travel_out type /dmo/travel,
             travel_set_status_booked LIKE line of result.


      clear result.

      loop at keys ASSIGNING FIELD-SYMBOL(<travel_set_status_booked>).

        data(travel_id) = <travel_set_status_booked>-TravelId.

        /dmo/cl_flight_legacy=>get_instance( )->set_status_to_booked(
          EXPORTING
            iv_travel_id = travel_id
          IMPORTING
            et_messages  = data(lt_messages)
        ).

                                "Step 4: Inform RAP about all the messages and errors
        /dmo/cl_flight_legacy=>get_instance( )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).

        "Step 5: Map the messages to RAP output
        map_messages(
          EXPORTING
            travel_id    = <travel_set_status_booked>-TravelId
            messages     = messages
          IMPORTING
            failed_added = data(data_failed)
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

        if data_failed = abap_false.

            /dmo/cl_flight_legacy=>get_instance( )->get_travel(
              EXPORTING
                iv_travel_id           = travel_id
                iv_include_buffer      = abap_false
               IMPORTING
                 es_travel              = travel_out
            ).

            travel_set_status_booked-%param = CORRESPONDING #( travel_out mapping to entity ).
            travel_set_status_booked-TravelId = travel_id.
            append travel_set_status_booked to result.

        endif.

      endloop.


  ENDMETHOD.

  METHOD map_messages.

     failed_Added = abap_False.

     loop at messages into data(message).

        if message-msgty = 'E' or message-msgty = 'A'.

            failed_Added = abap_true.
            append value #( %cid = cid travelid = travel_id
                            %fail-cause = /dmo/cl_travel_auxiliary=>get_cause_from_message(
                                            msgid        = message-msgid
                                            msgno        = message-msgno
*                                            is_dependend = abap_false
                                          )
            ) to failed.


        endif.

        append value #( %cid = cid travelid = travel_id
                        %msg = new_message(
                                            id = message-msgid
                                            number = message-msgno
                                            v1 = message-msgv1
                                            v2 = message-msgv2
                                            v3 = message-msgv3
                                            v4 = message-msgv4
                                            severity = cond #( when failed_Added = abap_true
                                                                then if_abap_behv_message=>severity-error
                                                                else if_abap_behv_message=>severity-information
                                            )
                         )
            ) to reported.

     endloop.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZATS_AB_TRAVEL_U DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZATS_AB_TRAVEL_U IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    /dmo/cl_flight_legacy=>get_instance( )->save(  ).

  ENDMETHOD.

  METHOD cleanup.

    /dmo/cl_flight_legacy=>get_instance( )->initialize(  ).

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
