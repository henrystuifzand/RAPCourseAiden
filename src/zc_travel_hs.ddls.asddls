@AccessControl.authorizationCheck: #NOT_REQUIRED 
@EndUserText.label: 'Projection view for Travel' 
@Metadata.ignorePropagatedAnnotations: true 
@Metadata.allowExtensions: true 
@Search.searchable: false 
@ObjectModel.semanticKey: ['travel_id'] 

define root view entity ZC_TRAVEL_HS provider contract transactional_query 
as projection on ZI_TRAVEL_HS 
{ 
    @Search.defaultSearchElement: true  
    @Search.fuzzinessThreshold: 1
    @ObjectModel.text.element: [ 'description' ] 
    key travel_id, 
    
    @ObjectModel.text.element: ['AgencyName']  
    agency_id,  
    
    @Search.defaultSearchElement: true  
    @Search.fuzzinessThreshold: 0.6
    _Agency.Name as AgencyName, 
    
    @Search.defaultSearchElement: true     
    @ObjectModel.text.element: [ 'FirstName' ] 
    customer_id, 
    
    _Customer.FirstName as CustFirstName,    
    _Customer.LastName as CustLastName, 
    customer_email,   
    FirstName, 
    LastName, 
    begin_date, 
    end_date, 
    
    @ObjectModel.text.element: ['StatusText']     
    status, 
    StatusText, 
    status_criticality,  
    
    @Semantics.amount.currencyCode: 'currency_code'      
    booking_fee, 
    
    @Semantics.amount.currencyCode: 'currency_code' 
    total_price, 
    
    @Semantics.amount.currencyCode: 'currency_code'  
    tax_price,     
    currency_code, 
   
    @Search.defaultSearchElement: true  
    @Search.fuzzinessThreshold: 0.8
    description, 
    rating_value, 
    created_by, 
    created_at, 
    last_changed_by, 
    last_changed_at,
    
    /* Associations */ 
    _Agency, 
    _Booking : redirected to composition child ZC_BOOKING_HS,
//    _BookingChart : redirected to composition child ZC_BOOKING_CHART,
//    _Attachments : redirected to composition child ZC_ATTACHMENTS,
     _Currency, 
     _Customer, 
     _CurrencyText, 
     _TravelStatus 
} 
