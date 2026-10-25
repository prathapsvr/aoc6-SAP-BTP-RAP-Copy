@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unmanaged Scenario Master data'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZATS_AB_AGENCY_U as select from /dmo/agency
association[1] to I_Country as _Country on
$projection.CountryCode = _Country.Country
{
    key agency_id as AgencyId,
    name as Name,
    street as Street,
    postal_code as PostalCode,
    city as City,
    country_code as CountryCode,
    email_address as EmailAddress,
    _Country
}
