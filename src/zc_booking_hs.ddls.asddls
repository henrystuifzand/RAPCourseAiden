@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Booking'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZC_BOOKING_HS as projection on ZI_BOOKING_HS
{
  key travel_id,

      @Search.defaultSearchElement: true
  key booking_id,
      booking_date,

      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'FirstName' ]
      customer_id,

      FirstName,
      LastName,
      flight_date,

      @Semantics.imageUrl: true
      flightimageurl,

      @Semantics.amount.currencyCode: 'currency_code'
      flight_price,
      currency_code,
      booking_location,

      @ObjectModel.text.element: ['BookingStatusText']
      booking_status,
      BookingStatusText,
      radial_value,
      progress_value,
      progress_criticality,
      booking_status_criticality,
      navigation_sobj,
      navigation_url,
      company,
      DistinctBookings,
      last_changed_at,

      /* Associations */
      _Customer,
      _BookingLocations,
      _Travel      : redirected to parent ZC_TRAVEL_HS
}
