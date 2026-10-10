@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity projection layer'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define root view entity ZATS_AB_M_TRAVEL_APPROVER as projection on ZATS_AB_M_TRAVEL
{
    key TravelId,
    AgencyId,
    CustomerId,
    BeginDate,
    EndDate,
    BookingFee,
    TotalPrice,
    CurrencyCode,
    Description,
    OverallStatus,
    /* Associations */
    _Agency,
    _Booking: redirected to composition child ZATS_AB_M_BOOKING_APPROVER,
    _Currency,
    _Customer,
    _OverallStatus,
    AgencyName,
    CustomerName,
    StatusText,
    Minion,
    ImageUrl
}
