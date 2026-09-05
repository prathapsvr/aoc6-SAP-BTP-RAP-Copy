CLASS zcl_ats_ab_cp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    data: itab type table of string.
    methods reach_to_mars.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ats_ab_cp IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    me->reach_to_mars( ).
    out->write(
      EXPORTING
        data   = itab
    ).
  ENDMETHOD.

  METHOD reach_to_mars.

    data lv_string type string.

    data(lo_earth) = new zcl_earth(  ).
    data(lo_iplanet1) = new zcl_ip(  ).
    data(lo_mars) = new zcl_mars(  ).

    lv_string = lo_earth->start_engine(  ).
    APPEND lv_string to itab.
    lv_string = lo_earth->lift_off( ).
    APPEND lv_string to itab.

    lv_string = lo_iplanet1->enter_orbit(  ).
    APPEND lv_string to itab.
    lv_string = lo_iplanet1->leave_orbit( ).
    APPEND lv_string to itab.


    lv_string = lo_mars->enter_orbit(  ).
    APPEND lv_string to itab.
    lv_string = lo_mars->explore( ).
    APPEND lv_string to itab.


  ENDMETHOD.

ENDCLASS.

