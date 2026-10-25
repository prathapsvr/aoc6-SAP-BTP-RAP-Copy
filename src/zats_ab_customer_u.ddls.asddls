@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer CDS entity for Unmanaged RAP'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZATS_AB_CUSTOMER_U as select from /dmo/customer
association[1] to I_Country as _Country on
$projection.CountryCode = _Country.Country
{
    key /dmo/customer.customer_id as CustomerId,
    /dmo/customer.first_name as FirstName,
    /dmo/customer.last_name as LastName,
    /dmo/customer.title as Title,
    /dmo/customer.street as Street,
    /dmo/customer.postal_code as PostalCode,
    /dmo/customer.city as City,
    /dmo/customer.country_code as CountryCode,
    _Country
}
