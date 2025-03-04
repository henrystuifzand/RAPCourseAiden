CLASS zcl_data_loader_hs DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      tt_agency     TYPE STANDARD TABLE OF ztb_agency_00 WITH KEY agency_id,
      tt_booking    TYPE STANDARD TABLE OF ztb_booking_hs WITH KEY booking_id,
      tt_customer   TYPE STANDARD TABLE OF ztb_customer_00 WITH KEY customer_id,
      tt_travel     TYPE STANDARD TABLE OF ztb_travel_hs WITH KEY travel_id,
      tt_status     TYPE STANDARD TABLE OF ztb_status_00 WITH KEY status,
      tt_statext    TYPE STANDARD TABLE OF ztb_statext_00 WITH KEY status,
      tt_bookingloc TYPE STANDARD TABLE OF ztb_bookingloc WITH KEY booking_id country.
    DATA : gt_agency     TYPE tt_agency,
           gt_booking    TYPE tt_booking,
           gt_customer   TYPE tt_customer,
           gt_travel     TYPE tt_travel,
           gt_Status     TYPE tt_status,
           gt_statext    TYPE tt_Statext,
           gt_bookingloc TYPE tt_bookingloc.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS: prepare_data.
ENDCLASS.



CLASS ZCL_DATA_LOADER_HS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*    DELETE FROM ztb_agency_00.
    DELETE FROM ztb_booking_HS.
*    DELETE FROM ztb_customer_00.
    DELETE FROM ztb_travel_HS.
*    DELETE FROM ztb_status_00.
*    DELETE FROM ztb_statext_00.
*    DELETE FROM ztb_bookingloc.

*
*
    me->prepare_data(  ).
*    IF me->gt_agency IS NOT INITIAL.
*      INSERT ztb_agency_00 FROM TABLE @me->gt_agency.
*    ENDIF.
*    IF me->gt_customer IS NOT INITIAL.
*      INSERT ztb_customer_00 FROM TABLE @me->gt_customer.
*    ENDIF.
    IF me->gt_booking IS NOT INITIAL.
      INSERT ztb_booking_HS FROM TABLE @me->gt_booking.
    ENDIF.
    IF me->gt_travel IS NOT INITIAL.
      INSERT ztb_travel_HS FROM TABLE @me->gt_travel.
    ENDIF.
*    IF me->gt_status IS NOT INITIAL.
*      INSERT ztb_status_00 FROM TABLE @me->gt_status.
*    ENDIF.
*    IF me->gt_statext IS NOT INITIAL.
*      INSERT ztb_statext_00 FROM TABLE @me->gt_statext.
*    ENDIF.
*    IF me->gt_bookingloc IS NOT INITIAL.
*      INSERT ztb_bookingloc FROM TABLE @me->gt_bookingloc.
*    ENDIF.

  ENDMETHOD.


  METHOD prepare_data.

    me->gt_status =  VALUE tt_Status( ( status = 'O' ) ( status = 'A' ) ( status = 'X' ) ).
    me->gt_statext =  VALUE tt_Statext( ( status = 'O' language = 'E' status_text = 'Open' )
                                       ( status = 'A' language = 'E' status_text = 'Accepted' )
                                       ( status = 'X' language = 'E' status_text = 'Closed' ) ).
    me->gt_agency = VALUE tt_agency(  ##NO_TEXT
           (
             agency_id = '70041'
             name      = 'Sunshine Travel'
             street    = '134 West Street         '
             postal_code  = '54323                   '
             city      = 'Rochester               '
             country_code   = 'US'
             phone_number = '+1 901-632-5620            '
             email_address = 'info@sunshine-travel.sap              '
             )
           (
             agency_id = '70046'
             name      = 'Fly High'
             street    = 'Berliner Allee 11       '
             postal_code  = '40880                   '
             city      = 'Duesseldorf              '
             country_code   = 'DE'
             phone_number = '+49 2102 69555             '
             email_address = 'info@flyhigh.sap                      '
             )
           (
             agency_id = '70003'
             name      = 'Happy Hopping'
             street    = 'Calvinstr. 36           '
             postal_code  = '13467                   '
             city      = 'Berlin                  '
             country_code   = 'DE'
             phone_number = '+49 30-8853-0              '
             email_address = 'info@haphop.sap                       '
             ) ).

    me->gt_customer = VALUE tt_customer(
                (     customer_id   = '594'
                      first_name    = 'Mark'
                      last_name     = 'Johnson'
                      street_name   = 'MarkStraat'
                      postal_code   = '1234 GG'
                      city          = 'Den Haag'
                      country_code  = 'NL'
                      phone_number  = '+31 123456789'
                      email_address = 'mark@gmail.com'
                  )
                  (   customer_id   = '648'
                      first_name    = 'Gido'
                      last_name     = 'Triest'
                      street_name   = 'Bolelaan'
                      postal_code   = '5678 GG'
                      city          = 'Amsterdam'
                      country_code  = 'NL'
                      phone_number  = '+31 123456789'
                      email_address = 'gido@gmail.com'
                   )
                  ).


    me->gt_travel = VALUE tt_travel(
    (
        travel_id = '202501'
        agency_id     = '70041'
        customer_id   = '594'
        begin_date    = cl_abap_context_info=>get_system_date( )
        end_date      = cl_abap_context_info=>get_system_date( )
        status        = 'A'
        status_criticality = '3'
        rating_value = '1'
        booking_fee   = '300'
        total_price   =  '1300.50'
        currency_code = 'EUR'
        description   = 'Travel Plan1'
     )
     (
        travel_id = '202502'
        agency_id     = '70046'
        customer_id   = '648'
        status        = 'O'
        status_criticality = '2'
        begin_date    = cl_abap_context_info=>get_system_date( )
        end_date      = cl_abap_context_info=>get_system_date( )
        booking_fee   = '300'
        rating_value = '3'
        total_price   =  '2800.00'
        currency_code = 'EUR'
        description   = 'Travel Plan2'
     )
     (
        travel_id     = '802502'
        agency_id     = '70003'
        customer_id   = '648'
        status        = 'X'
        status_criticality = '1'
        rating_value = '5'
        begin_date    = cl_abap_context_info=>get_system_date( )
        end_date      = cl_abap_context_info=>get_system_date( )
        booking_fee   = '200'
        total_price   =  '5000.00'
        currency_code = 'AED'
        description   = 'Travel Plan 3x'
     )
     ).
    DATA(random_generator) = cl_abap_random=>create( seed = CONV #( cl_abap_context_info=>get_system_time(  ) ) ).

    LOOP AT me->gt_travel INTO DATA(wa_travel).

      APPEND LINES OF VALUE tt_booking( (
      travel_id = wa_travel-travel_id
      booking_id          = random_generator->intinrange( low = 1 high = 1000 )
      booking_date        =  cl_abap_context_info=>get_system_date( )
      customer_id         = wa_travel-customer_id
      flight_date         = cl_abap_context_info=>get_system_date( )
      booking_status = 'O'
      radial_value =  26
      progress_value = 85
      flight_price        = '1000.50'
      flightimageurl = 'https://raw.githubusercontent.com/SAP-samples/fiori-elements-opensap/main/week1/images/airlines/Green-Albatross-logo.png'
      navigation_sobj = '0000000428'
      navigation_url = 'https://www.sap.com'
      company = 'SAP'
      currency_code       = 'EUR' )
      (
      travel_id = wa_travel-travel_id
      booking_id          =  random_generator->intinrange( low = 1 high = 1000 )
      booking_date        =  cl_abap_context_info=>get_system_date( )
      customer_id         = wa_travel-customer_id
      booking_status = 'A'
      flight_date         = cl_abap_context_info=>get_system_date( )
      flight_price        = '2500.00'
      flightimageurl = 'https://raw.githubusercontent.com/SAP-samples/fiori-elements-opensap/main/week1/images/airlines/Fly-Africa-logo.png'
      navigation_sobj = '0000000428'
      navigation_url = 'https://www.sap.com'
      company = 'SAP'
      radial_value =  78
      progress_value =  60
      currency_code       = 'EUR' )
      (
      travel_id = wa_travel-travel_id
      booking_id          =  random_generator->intinrange( low = 1 high = 1000 )
      booking_date        =  cl_abap_context_info=>get_system_date( )
      customer_id         = wa_travel-customer_id
      booking_status = 'A'
      flight_date         = cl_abap_context_info=>get_system_date( )
      flight_price        = '2500.00'
      flightimageurl = 'https://raw.githubusercontent.com/SAP-samples/fiori-elements-opensap/main/week1/images/airlines/Fly-Africa-logo.png'
      navigation_sobj = '0000000428'
      navigation_url = 'https://www.sap.com'
      company = 'SAP'
      radial_value =  78
      progress_value =  60
      currency_code       = 'EUR' )
                  (
      travel_id = wa_travel-travel_id
      booking_id          =  random_generator->intinrange( low = 1 high = 1000 )
      booking_date        =  cl_abap_context_info=>get_system_date( )
      customer_id         = wa_travel-customer_id
      booking_status    = 'X'
      flight_date         = cl_abap_context_info=>get_system_date( )
      flight_price        = '1500.00'
      flightimageurl = 'https://raw.githubusercontent.com/SAP-samples/fiori-elements-opensap/main/week1/images/airlines/Fly-Africa-logo.png'
      navigation_sobj = '0000000428'
      navigation_url = 'https://www.sap.com'
      company = 'SAP'
      radial_value =  63
      progress_value = 42
      currency_code       = 'EUR' )
      (
      travel_id = wa_travel-travel_id
      booking_id          =  random_generator->intinrange( low = 1 high = 1000 )
      booking_date        =  cl_abap_context_info=>get_system_date( )
      customer_id         = wa_travel-customer_id
      booking_status      = 'O'
      flight_date         = cl_abap_context_info=>get_system_date( )
      flight_price        = '9500.00'
      flightimageurl      = 'https://raw.githubusercontent.com/SAP-samples/fiori-elements-opensap/main/week1/images/airlines/Fly-Africa-logo.png'
      navigation_sobj     = '0000000428'
      navigation_url      = 'https://www.sap.com'
      company             = 'SAP'
      radial_value        =  68
      progress_value       =  30
      currency_code       = 'EUR' )
      ) TO me->gt_booking.

    ENDLOOP.

    LOOP AT me->gt_booking INTO DATA(wa_booking).
      APPEND LINES OF VALUE tt_bookingloc(    ( travel_id = wa_booking-travel_id booking_id = wa_booking-booking_id country = 'NL' description = 'Netherlands' )
                                              ( travel_id = wa_booking-travel_id booking_id = wa_booking-booking_id country = 'IT' description = 'Italy' )
                                              ( travel_id = wa_booking-travel_id booking_id = wa_booking-booking_id country = 'DE' description = 'Germany' )
                                              ( travel_id = wa_booking-travel_id booking_id = wa_booking-booking_id country = 'PL' description = 'Poland' )
                                              ( travel_id = wa_booking-travel_id booking_id = wa_booking-booking_id country = 'FR' description = 'France' )
                                              ( travel_id = wa_booking-travel_id booking_id = wa_booking-booking_id country = 'BE' description = 'Belgium' )
       ) TO me->gt_bookingloc.
    ENDLOOP.


  ENDMETHOD.
ENDCLASS.
