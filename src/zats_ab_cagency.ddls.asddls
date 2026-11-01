@EndUserText.label: 'Custom Entity for External Agency Data'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_ATS_AB_AGENCY'
define custom entity ZATS_AB_CAGENCY
{
  key AgencyId : abap.char( 6 );
  Name : abap.char( 31 );
  Street: abap.char( 30 );
  PostalCode: abap.char( 10 );
  City: abap.char( 25 );
  Country: abap.char( 3 );
  PhoneNumber: abap.char( 30 );
  WebAddress: abap.char( 255 );
  
}
