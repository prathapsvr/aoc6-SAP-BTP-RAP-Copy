@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total Sales by Dimentions'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
define view entity ZC_ATS_AB_TOT_SALES as select from ZI_ATS_AB_CO_SLS_CUBE
{
    
    key ProductCategory,
    key CompanyName,
    key Country,
    key Currency,
    Amount
    
}
