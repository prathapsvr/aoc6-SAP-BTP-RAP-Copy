CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS earlynumbering_cba_Booksuppl FOR NUMBERING
       entities FOR CREATE Booking\_Booksuppl.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Booksuppl.
    ""HOMEWORK: Implement logic to generate supplement id's as starring point of booking
    ""id and +1
  ENDMETHOD.

ENDCLASS.
