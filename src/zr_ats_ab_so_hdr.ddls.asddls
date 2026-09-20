@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZATS_AB_SO_HDR'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_ATS_AB_SO_HDR
  as select from ZATS_AB_SO_HDR
{
  key order_id as OrderID,
  order_no as OrderNo,
  buyer as Buyer,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  gross_amount as GrossAmount,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency_code as CurrencyCode,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  changed_by as ChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  changed_at as ChangedAt
}
