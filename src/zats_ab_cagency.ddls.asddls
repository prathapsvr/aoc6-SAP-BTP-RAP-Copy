@EndUserText.label: 'Custom Entity for External Agency Data'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_ATS_AB_AGENCY'
define custom entity ZATS_AB_CAGENCY
{
  key agency_id    : abap.char( 6 );
      name         : abap.char( 31 );
      street       : abap.char( 30 );
      postal_code  : abap.char( 10 );
      city         : abap.char( 25 );
      country      : abap.char( 3 );   
      phone_number : abap.char( 30 );
      web_address  : abap.char( 255 );
}
