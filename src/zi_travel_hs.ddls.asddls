@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composition view for Travel'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity ZI_TRAVEL_HS as select from ztb_travel_hs
    composition [0..*] of ZI_BOOKING_HS       as _Booking
//  composition [0..*] of ZI_BOOKING_CHART as _BookingChart
    association [0..1] to I_Currency       as _Currency     on $projection.currency_code = _Currency.Currency
    association [0..1] to ZI_AGENCY        as _Agency       on $projection.agency_id = _Agency.AgencyID
    association [0..1] to ZI_CUSTOMER      as _Customer     on $projection.customer_id = _Customer.CustomerID
    association [0..*] to ZI_CURRENCYTEXT  as _CurrencyText on $projection.currency_code = _CurrencyText.Currency
    association [1..*] to ZI_STATUSTEXT_VH as _TravelStatus on $projection.status = _TravelStatus.TravelStatus
//  composition [1..*] of ZI_ATTACHEMENTS  as _Attachments
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.5      
  key travel_id,
      agency_id,
      customer_id,
      _Customer.FirstName as FirstName,
      _Customer.LastName  as LastName,
      customer_email,
      begin_date,
      end_date,
      status,
      _TravelStatus.Text  as StatusText,
      case status
          when 'O' then 2 -- 'open' | 2: yellow colour
          when 'A' then 3 -- 'accepted' | 3: green colour
          when 'X' then 1 -- 'rejected' | 1: red colour
          else 0 -- 'nothing' | 0: unknown
      end                 as status_criticality,

      @Semantics.amount.currencyCode: 'currency_code'
      booking_fee,

      @Semantics.amount.currencyCode: 'currency_code'
      total_price,

      @Semantics.amount.currencyCode: 'currency_code'
      tax_price,

      @ObjectModel.text.association: '_CurrencyText'
      currency_code,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.5
      description,

      rating_value,

      @Semantics.user.createdBy: true
      created_by,

      @Semantics.systemDateTime.createdAt: true
      created_at,

      @Semantics.user.localInstanceLastChangedBy: true
      last_changed_by,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at,

      /* Associations */

      _Booking,
        _Currency,
        _Agency,
        _Customer,
        _CurrencyText,
        _TravelStatus
//      _BookingChart,
//      _Attachments
}
