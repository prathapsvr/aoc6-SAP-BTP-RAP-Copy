@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Processor Supplement data'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define view entity ZATS_AB_M_BOOKSUPPL_PROCESSOR as projection on ZATS_AB_M_BOOKSUPPL
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    SupplementId,
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Booking:  redirected to parent ZATS_AB_M_BOOKING_PROCESSOR,
    _Product,
    _ProductText,
    _Travel: redirected to ZATS_AB_M_TRAVEL_PROCESSOR
}
