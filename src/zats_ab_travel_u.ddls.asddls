@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unamaged RAP Scenario'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZATS_AB_TRAVEL_U as select from /dmo/travel as Travel
association[1] to ZATS_AB_AGENCY_U as _Agency on 
    $projection.AgencyId = _Agency.AgencyId
association[1] to ZATS_AB_CUSTOMER_U as _Customer on
    $projection.CustomerId = _Customer.CustomerId
association[1] to I_Currency as _Currency on
    $projection.CurrencyCode = _Currency.Currency
association[1] to /DMO/I_Travel_Status_VH as _TravelStatus on
    $projection.Status = _TravelStatus.TravelStatus
{
    @ObjectModel.text.element: [ 'Memo' ]
    key Travel.travel_id as TravelId,
    @ObjectModel.text.element: [ 'AgencyName' ]
    @Consumption.valueHelpDefinition: [{ 
            entity: { name: 'ZATS_AB_AGENCY_U', element: 'AgencyId' }
     }]
    Travel.agency_id as AgencyId,
    _Agency.Name as AgencyName,
    @ObjectModel.text.element: [ 'CustomerName' ]
    @Consumption.valueHelpDefinition: [{ 
            entity: { name: 'ZATS_AB_CUSTOMER_U', element: 'CustomerId' }
     }]
    Travel.customer_id as CustomerId,
    _Customer.LastName as CustomerName,
    Travel.begin_date as BeginDate,
    Travel.end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Travel.booking_fee as BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Travel.total_price as TotalPrice,
    @ObjectModel.text.element: [ 'CurrencyName' ]
    @Consumption.valueHelpDefinition: [{ 
            entity: { name: 'I_Currency', element: 'Currency' }
     }]
    Travel.currency_code as CurrencyCode,
    _Currency._Text[Language = $session.system_language].CurrencyName as CurrencyName,
    Travel.description as Memo,
    @ObjectModel.text.element: [ 'StatusText' ]
    @Consumption.valueHelpDefinition: [{ 
            entity: { name: '/DMO/I_Travel_Status_VH', element: 'TravelStatus' }
     }]
    Travel.status as Status,
    _TravelStatus._Text[Language = $session.system_language].Text as StatusText,
    Travel.createdby as Createdby,
    Travel.createdat as Createdat,
    Travel.lastchangedby as Lastchangedby,
    Travel.lastchangedat as Lastchangedat,
    _Agency,
    _Customer,
    _Currency,
    _TravelStatus
}
