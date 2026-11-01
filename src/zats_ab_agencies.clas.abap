"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>ZTRAVEL_AGENCY_AB_CDS</em>
CLASS zats_ab_agencies DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized">ztravel_agency_abType</p>
      BEGIN OF tys_ztravel_agency_ab_type,
        "! <em>Key property</em> AgencyId
        agency_id             TYPE c LENGTH 6,
        "! Name
        name                  TYPE c LENGTH 80,
        "! Street
        street                TYPE c LENGTH 60,
        "! PostalCode
        postal_code           TYPE c LENGTH 10,
        "! City
        city                  TYPE c LENGTH 40,
        "! Country
        country               TYPE c LENGTH 3,
        "! PhoneNumber
        phone_number          TYPE c LENGTH 30,
        "! WebAddress
        web_address           TYPE c LENGTH 255,
        "! LocalCreatedBy
        local_created_by      TYPE c LENGTH 12,
        "! LocalCreatedAt
        local_created_at      TYPE timestampl,
        "! LocalLastChangedBy
        local_last_changed_by TYPE c LENGTH 12,
        "! LocalLastChangedAt
        local_last_changed_at TYPE timestampl,
        "! LastChangedAt
        last_changed_at       TYPE timestampl,
      END OF tys_ztravel_agency_ab_type,
      "! <p class="shorttext synchronized">List of ztravel_agency_abType</p>
      tyt_ztravel_agency_ab_type TYPE STANDARD TABLE OF tys_ztravel_agency_ab_type WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! ztravel_agency_ab
        "! <br/> Collection of type 'ztravel_agency_abType'
        ztravel_agency_ab TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'ZTRAVEL_AGENCY_AB',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized">Internal names for ztravel_agency_abType</p>
        "! See also structure type {@link ..tys_ztravel_agency_ab_type}
        BEGIN OF ztravel_agency_ab_type,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF ztravel_agency_ab_type,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define ztravel_agency_abType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_ztravel_agency_ab_type RAISING /iwbep/cx_gateway.

ENDCLASS.



CLASS ZATS_AB_AGENCIES IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'ZTRAVEL_AGENCY_AB_CDS' ) ##NO_TEXT.

    def_ztravel_agency_ab_type( ).

  ENDMETHOD.


  METHOD def_ztravel_agency_ab_type.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'ZTRAVEL_AGENCY_AB_TYPE'
                                    is_structure              = VALUE tys_ztravel_agency_ab_type( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'ztravel_agency_abType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'ZTRAVEL_AGENCY_AB' ).
    lo_entity_set->set_edm_name( 'ztravel_agency_ab' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'AGENCY_ID' ).
    lo_primitive_property->set_edm_name( 'AgencyId' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 6 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'NAME' ).
    lo_primitive_property->set_edm_name( 'Name' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 80 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'STREET' ).
    lo_primitive_property->set_edm_name( 'Street' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 60 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'POSTAL_CODE' ).
    lo_primitive_property->set_edm_name( 'PostalCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CITY' ).
    lo_primitive_property->set_edm_name( 'City' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COUNTRY' ).
    lo_primitive_property->set_edm_name( 'Country' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PHONE_NUMBER' ).
    lo_primitive_property->set_edm_name( 'PhoneNumber' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'WEB_ADDRESS' ).
    lo_primitive_property->set_edm_name( 'WebAddress' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 255 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LOCAL_CREATED_BY' ).
    lo_primitive_property->set_edm_name( 'LocalCreatedBy' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LOCAL_CREATED_AT' ).
    lo_primitive_property->set_edm_name( 'LocalCreatedAt' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 7 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LOCAL_LAST_CHANGED_BY' ).
    lo_primitive_property->set_edm_name( 'LocalLastChangedBy' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LOCAL_LAST_CHANGED_AT' ).
    lo_primitive_property->set_edm_name( 'LocalLastChangedAt' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 7 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGED_AT' ).
    lo_primitive_property->set_edm_name( 'LastChangedAt' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 7 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.
ENDCLASS.
