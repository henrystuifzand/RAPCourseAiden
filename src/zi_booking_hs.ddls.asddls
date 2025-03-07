@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composition view for Booking'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKING_HS as select from ztb_booking_hs
  association        to parent ZI_TRAVEL_HS as _Travel           on $projection.travel_id = _Travel.travel_id
  association [0..1] to ZI_CUSTOMER      as _Customer         on $projection.customer_id = _Customer.CustomerID
  association [1..*] to ZI_STATUSTEXT_VH as _TravelStatus     on $projection.booking_status = _TravelStatus.TravelStatus
  association [1..*] to ZI_BOOKINGLOC    as _BookingLocations on $projection.travel_id  = _BookingLocations.travel_id                                                             and $projection.booking_id = _BookingLocations.booking_id
{
  key travel_id,
  key booking_id,
      booking_date,
      customer_id,
      flight_date,

      @Semantics.amount.currencyCode: 'currency_code'
      @Aggregation.default: #SUM
      flight_price,

      @Semantics.imageUrl: true
      // @UI.textArrangement: #TEXT_ONLY
      flightimageurl,
      currency_code,
      booking_location,
      booking_status,
      _TravelStatus.Text   as BookingStatusText,
      radial_value,
      progress_value,

      //@Aggregation.referenceElement: ['booking_id']
      //@Aggregation.default: #COUNT_DISTINCT
      cast(1 as abap.int4) as DistinctBookings,

      case when progress_value >= 75 then 3
             when progress_value >= 50 then 2
              else 1 end   as progress_criticality,

      case when booking_status = 'A' then 3
              when booking_status = 'O' then 2
              else 1 end   as booking_status_criticality,

      navigation_sobj,
      navigation_url,
      company,
      _Customer.FirstName  as FirstName,
      _Customer.LastName   as LastName,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at,

      /* Associations */
      _Travel,
      _Customer,
      _TravelStatus,
      _BookingLocations
}
