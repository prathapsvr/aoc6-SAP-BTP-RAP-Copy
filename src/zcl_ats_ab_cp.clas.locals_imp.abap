*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class zcl_earth definition.

    PUBLIC SECTION.

    methods: start_engine retURNING VALUE(e_result) type string,
             lift_off retURNING VALUE(e_result) type string.
endclass.

class zcl_earth impleMENTATION.

  METHOD lift_off.
    e_result = |We took off from earth|.
  ENDMETHOD.

  METHOD start_engine.
    e_result = |Roger we started the engine|.
  ENDMETHOD.

endCLASS.

class zcl_ip definition.

        PUBLIC SECTION.

    methods: enter_orbit retURNING VALUE(e_result) type string,
             leave_orbit retURNING VALUE(e_result) type string.
endclass.

class zcl_ip impleMENTATION.

  METHOD enter_orbit.
    e_result = |Medde We enter the orbit of planet 1|.
  ENDMETHOD.

  METHOD leave_orbit.
    e_result = |Medde We are leaving the orbit of planet 1|.
  ENDMETHOD.

endCLASS.

class zcl_mars definition.
        PUBLIC SECTION.

    methods: enter_orbit retURNING VALUE(e_result) type string,
             explore retURNING VALUE(e_result) type string.
endclass.

class zcl_mars impleMENTATION.

  METHOD enter_orbit.
    e_result = |Medde We enter the orbit of MARS|.
  ENDMETHOD.

  METHOD explore.
    e_result = |Elon Buddy we found the water|.
  ENDMETHOD.

endCLASS.
