@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'booking processor'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define view entity ZATS_AB_M_BOOKING_PROCESSOR as projection on ZATS_AB_M_BOOKING
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    BookingStatusText,
    AirlineName,
    CustomerName,
    /* Associations */
    _BookStatus,
    _BookSuppl: redirected to composition child ZATS_AB_M_BOOKSUPPL_PROCESSOR,
    _Carrier,
    _Connection,
    _Currency,
    _Customer,
    _Travel: redirected to parent ZATS_AB_M_TRAVEL_PROCESSOR
}
