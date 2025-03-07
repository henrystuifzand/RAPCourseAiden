CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS: BEGIN OF lc_status,
                 accepted  TYPE c LENGTH 1 VALUE 'A',
                 cancelled TYPE c LENGTH 1 VALUE 'X',
                 open      TYPE c LENGTH 1 VALUE 'O',
               END OF lc_Status.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS calculateTotalTax FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Travel~calculateTotalTax.
    METHODS validateEmail FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateEmail.
    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDates.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_travel_hs IN LOCAL MODE ENTITY Travel
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travels).

    result = VALUE #( FOR ls_travel IN lt_travels LET is_acc = COND #( WHEN ls_travel-status = lc_status-open OR
                                                                            ls_travel-status = lc_status-cancelled
                                                                       THEN if_abap_behv=>fc-o-enabled
                                                                       ELSE if_abap_behv=>fc-o-disabled )

                                                      is_rej = COND #( WHEN ls_travel-status = lc_status-open OR
                                                                            ls_travel-status = lc_status-accepted
                                                                       THEN if_abap_behv=>fc-o-enabled
                                                                       ELSE if_abap_behv=>fc-o-disabled )
                                    IN    ( %tky = ls_travel-%tky %action-acceptTravel = is_acc %action-rejectTravel = is_rej ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD acceptTravel.
  " Set as Accepted
        MODIFY ENTITIES OF zi_travel_hs IN LOCAL MODE ENTITY Travel
        UPDATE FIELDS ( status status_criticality )
        WITH VALUE #( FOR key IN keys (  %tky = key-%tky  status = lc_status-accepted status_criticality = 3 ) )
        FAILED failed
        REPORTED reported.

    " Fill the response table
        READ ENTITIES OF zi_travel_hs IN LOCAL MODE ENTITY Travel
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travels).

        result = VALUE #( FOR ls_travel IN lt_travels ( %tky = ls_travel-%tky %param = ls_travel ) ).
  ENDMETHOD.

  METHOD rejectTravel.
  " Set as Rejected
        MODIFY ENTITIES OF zi_travel_hs IN LOCAL MODE ENTITY Travel
        UPDATE FIELDS ( status status_criticality )
        WITH VALUE #( FOR key IN keys ( %tky = key-%tky status = lc_status-cancelled status_criticality = 1 ) )
        FAILED failed
        REPORTED reported.

        " Fill the response table
        READ ENTITIES OF zi_travel_hs IN LOCAL MODE ENTITY Travel
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travels).
        result = VALUE #( FOR ls_travel IN lt_travels ( %tky = ls_travel-%tky %param = ls_travel ) ).
  ENDMETHOD.

  METHOD calculateTotalTax.
  READ ENTITIES OF zi_travel_hs IN LOCAL MODE ENTITY travel
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travels).

        LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<lfs_travel>).
            <lfs_travel>-tax_price = ( <lfs_travel>-booking_fee * 21 ) / 100.
            <lfs_travel>-total_price = <lfs_travel>-booking_fee + <lfs_travel>-tax_price.
        ENDLOOP.

        MODIFY ENTITIES OF zi_travel_hs IN LOCAL MODE ENTITY travel
        UPDATE FIELDS ( tax_price total_price )
        WITH VALUE #( FOR ls_travel IN lt_Travels (
                        %tky = ls_travel-%tky
                        tax_price = ls_Travel-tax_price
                        total_price = ls_travel-total_price
                        %control-tax_price = if_abap_behv=>mk-on
                        %control-total_price = if_abap_behv=>mk-on ) )
        REPORTED DATA(update_reported).

        reported-travel = CORRESPONDING #( update_reported-travel ).
  ENDMETHOD.

  METHOD validateEmail.
     DATA: go_regex TYPE REF TO cl_abap_regex,
              go_matcher TYPE REF TO cl_abap_matcher,
              go_match TYPE c LENGTH 1.

        CREATE OBJECT go_regex EXPORTING pattern = '\w+(\.\w+)*@(\w+\.)+(\w{2,4})' ignore_case = abap_true.

        READ ENTITIES OF zi_travel_hs IN LOCAL MODE ENTITY Travel
        FIELDS ( customer_email ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travels).

        LOOP AT lt_travels INTO DATA(ls_Travel).
        go_matcher = go_regex->create_matcher( text = ls_travel-customer_email ).
            IF go_matcher->match( ) IS INITIAL.
                APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.
                APPEND VALUE #( %tky = ls_travel-%tky %state_area = 'VALIDATE_EMAIL'
                                %msg = new_message( id = '00' number = '001' v1 = 'Invalid Email' severity = if_abap_behv_message=>severity-error )
                                %element-customer_Email = if_abap_behv=>mk-on )
                TO reported-travel.
            ELSE.
                APPEND VALUE #( %tky = ls_Travel-%tky %state_area = 'VALIDATE_EMAIL' ) TO reported-travel.
            ENDIF.
        ENDLOOP.
  ENDMETHOD.

  METHOD validateDates.
*        Read Dates
        READ ENTITIES OF zi_travel_hs IN LOCAL MODE ENTITY Travel
        FIELDS ( begin_Date end_date ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travels).

        LOOP AT lt_travels INTO DATA(ls_Travel).
            IF ls_travel-begin_date > ls_travel-end_date.
                APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.
                APPEND VALUE #( %tky = ls_travel-%tky  %state_area = 'VALIDATE_DATES'
                                %msg = new_message( id = '00' number = '001' v1 = 'Invalid Dates' severity = if_abap_behv_message=>severity-error )
                                %element-begin_date = if_abap_behv=>mk-on
                                %element-End_date = if_abap_behv=>mk-on )
                TO reported-travel.
            ENDIF.
        ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Booking RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Booking RESULT result.

    METHODS setDefault FOR MODIFY
      IMPORTING keys FOR ACTION Booking~setDefault RESULT result.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD setDefault.
  ENDMETHOD.

ENDCLASS.
