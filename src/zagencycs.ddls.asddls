@EndUserText.label: 'Custom Entity Agency'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CS_AGENCY'
define custom entity ZAGENCYCS
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
