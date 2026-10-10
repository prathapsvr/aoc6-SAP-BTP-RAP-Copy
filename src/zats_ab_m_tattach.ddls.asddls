@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attachment Child CDS entity for travel'
@Metadata.ignorePropagatedAnnotations: false
define view entity ZATS_AB_M_TATTACH as select from zats_ab_att
--ask student whether the person is papa or not
association to parent ZATS_AB_M_TRAVEL as _Travel on
    $projection.TravelId = _Travel.TravelId
{
    key travel_id as TravelId,
    @EndUserText.label: 'Attach ID'
    key id as Id,
    @EndUserText.label: 'Comments'
    memo as Memo,
    @EndUserText.label: 'Attachment'
    @Semantics.largeObject : {
        mimeType: 'Filetype',
        fileName: 'Filename',
        contentDispositionPreference: #INLINE,
        acceptableMimeTypes: [ 'application/pdf','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ]
    }
    attachment as Attachment,
    @EndUserText.label: 'File Name'
    filename as Filename,
    @EndUserText.label: 'File Type'
    filetype as Filetype,
    @Semantics.user.createdBy: true
    local_created_by as LocalCreatedBy,
    @Semantics.systemDateTime.createdAt: true
    local_created_at as LocalCreatedAt,
    @Semantics.user.lastChangedBy: true
    local_last_changed_by as LocalLastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    local_last_changed_at as LocalLastChangedAt,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    _Travel
}
