CLASS zcl_ats_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ats_demo IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "write: 'welcome to abap on cloud'.
    out->write(
      EXPORTING
        data   = |Welcome to abap on cloud|
*        name   =
*      RECEIVING
*        output =
    ).

    select * from I_ExchangeRateRawData into table @data(itab) up TO 2 rows.

    out->write(
      EXPORTING
        data   = itab
*        name   =
*      RECEIVING
*        output =
    ).

  ENDMETHOD.
ENDCLASS.


