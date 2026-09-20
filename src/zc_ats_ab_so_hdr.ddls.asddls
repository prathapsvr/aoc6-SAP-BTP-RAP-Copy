@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZATS_AB_SO_HDR'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_ATS_AB_SO_HDR
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_ATS_AB_SO_HDR
  association [1..1] to ZR_ATS_AB_SO_HDR as _BaseEntity on $projection.ORDERID = _BaseEntity.ORDERID
{
  key OrderID,
  OrderNo,
  Buyer,
  @Semantics: {
    Amount.Currencycode: 'CurrencyCode'
  }
  GrossAmount,
  @Consumption: {
    Valuehelpdefinition: [ {
      Entity.Element: 'Currency', 
      Entity.Name: 'I_CurrencyStdVH', 
      Useforvalidation: true
    } ]
  }
  CurrencyCode,
  @Semantics: {
    User.Createdby: true
  }
  CreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  CreatedAt,
  @Semantics: {
    User.Lastchangedby: true
  }
  ChangedBy,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  ChangedAt,
  _BaseEntity
}
