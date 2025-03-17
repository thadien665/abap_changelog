*----------------------------------------------------------------------*
***INCLUDE ZCLIENT_MANAGEMENT_USER_COMI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

*### Declaration of actions for each customer modification option:
*### CLEAR_BTN - to clear all fields so user doesn't have to clear all manually
*### CREATE_BTN - new customer creation
*### SEARCH_BTN - searching for customer
*### UPDATE_BTN - updating basic data (names and email) of customer
*### UPDATE_ADRES_BTN - updating address data of customer
*### REFRESH - actually not controlled by user - used only for ALV hotspot event
*### BACK - to leave transaction code of program
*### LOG_BTN - to open changelog screen
*### ADRES_BTN - to show/hide customer's address fields and labels
*### DELETE_BTN - removing customer.

  CASE sy-ucomm.

    WHEN 'CLEAR_BTN'.

      CLEAR: input_first_name, input_last_name, input_email.

    WHEN 'CREATE_BTN'.

      "### All 3 values are mandatory to provide ###"
      IF input_first_name IS INITIAL OR input_last_name IS INITIAL OR input_email IS INITIAL.
        lv_create_flag = 'X'.
        MESSAGE i002(zmsgclass). "MSG: please fill in all required fields
      ELSE.
        lv_create_flag = ''.
      ENDIF.

      "### Validating correctness of data provided by user before creating new entry
      IF lv_create_flag = ''.
        DATA(lv_fname_validation) = lo_data_validator->names_validation( EXPORTING
                                                                            name = input_first_name
                                                                        ).
        IF lv_fname_validation = abap_false.
          lv_create_flag = 'X'.
          MESSAGE i006(zmsgclass). "MSG: Incorrect values in first name (only latin letters and spaces allowed)
        ELSE.
          lv_create_flag = ''.
        ENDIF.
      ENDIF.

      IF lv_create_flag = ''.
        DATA(lv_lname_validation) = lo_data_validator->names_validation( EXPORTING
                                                                            name = input_last_name
                                                                        ).
        IF lv_lname_validation = abap_false.
          lv_create_flag = 'X'.
          MESSAGE i007(zmsgclass). "MSG: Incorrect values in last name (only latin letters and spaces allowed)
        ELSE.
          lv_create_flag = ''.
        ENDIF.
      ENDIF.

      IF lv_create_flag = ''.
        DATA(lv_email_validation) = lo_data_validator->email_validation( EXPORTING
                                                                            email = input_email
                                                                        ).
        IF lv_email_validation = abap_false.
          lv_create_flag = 'X'.
          MESSAGE i008(zmsgclass). "MSG: Incorrect values in email (letters.digits@lettersdigits.domain allowed)
        ELSE.
          lv_create_flag = ''.
        ENDIF.

      ENDIF.

      "### If data is correct, creation will be done with adding new entries in changelog.
      IF lv_create_flag = ''.
        customer->create_customer( EXPORTING
                                   lv_first_name = input_first_name
                                   lv_last_name = input_last_name
                                   lv_email = input_email
                                   IMPORTING
                                   status = DATA(create_status)
                                   customer_id = DATA(customer_id) ).
        IF create_status = abap_true.
          DATA lt_changelog_data_1 TYPE  zcl_changelog_updater=>lt_flds_values.

          lt_changelog_data_1 = VALUE #( ( fld_name = 'First name' v_before = '' v_after = input_first_name )
                                       ( fld_name = 'Last name' v_before = '' v_after = input_last_name )
                                       ( fld_name = 'Email' v_before = '' v_after = input_email )
                                       ( fld_name = 'Customer id' v_before = '' v_after = customer_id )
                                     ).

          lo_changelog->getting_data( user = CONV zcsyuname( sy-uname )
                                      date = sy-datum
                                      time = sy-uzeit
                                      customer = customer_id
                                      oper_type = 'CREATE'
                                      lt_flds_values = lt_changelog_data_1 ).

          MESSAGE i001(zmsgclass).

          CLEAR: input_first_name, input_last_name, input_email.
        ELSE.
          MESSAGE i005(zmsgclass). "MSG: Cannot create customer
        ENDIF.
      ENDIF.

    WHEN 'SEARCH_BTN'.

      "### Search should be available with at least one criteria.
      IF input_first_name IS INITIAL AND input_last_name IS INITIAL AND input_email IS INITIAL.
        MESSAGE s003(zmsgclass). "MSG: Please enter at least one search criteria
      ENDIF.

      "### Creating search result ALV table in subscreen_1 and setting hotspot event.
      IF lo_alv_grid IS INITIAL.
        lo_alv_container = NEW cl_gui_custom_container( 'SUBSCREEN_1' ).
        lo_alv_grid = NEW cl_gui_alv_grid( lo_alv_container ).
        SET HANDLER lo_alv_events->hotspot FOR lo_alv_grid.

        customer->search_cusomer(   EXPORTING
                                lv_first_name = input_first_name
                                lv_last_name = input_last_name
                                lv_email = input_email
                                IMPORTING
                                lt_customer_data = lt_imported_cust_data ).

        lo_alv_events->prep_data( EXPORTING lt_needed_data = lt_imported_cust_data ).

        lo_alv_grid->set_table_for_first_display( EXPORTING
                                                  is_layout = gs_layout
                                                CHANGING
                                                it_outtab = lt_imported_cust_data
                                                it_fieldcatalog = lt_fieldcatalog ).

      ELSE.

        customer->search_cusomer(   EXPORTING
                                lv_first_name = input_first_name
                                lv_last_name = input_last_name
                                lv_email = input_email
                                IMPORTING
                                lt_customer_data = lt_imported_cust_data ).

        lo_alv_events->prep_data( EXPORTING lt_needed_data = lt_imported_cust_data ).

        lo_alv_grid->refresh_table_display(  ).

      ENDIF.



    WHEN 'UPDATE_BTN'.

      "### Update process uses lv_update_flag to distinguish if any validation is wrong
      "### to eventually stop the process and show message window to user.

      lv_update_flag = ''.
      DATA(lo_db_comparison) = NEW zcl_db_comparison(  ).

      "### Gathering data from before the update for further changelog entries
      DATA(lwa_data_before) = lo_alv_events->returning_data(  ).

      DATA(lt_data_before) = VALUE zcust_details( cust_fname = lwa_data_before-cust_fname
                                                cust_lname = lwa_data_before-cust_lname
                                                cust_email = lwa_data_before-cust_email ).
      "### Validation of user's input.
      DATA(lv_2nd_fname_validation) = lo_data_validator->names_validation( input_first_name_2 ).
      IF lv_2nd_fname_validation = abap_false.
        lv_update_flag = 'X'.
        MESSAGE i006(zmsgclass). "MSG: Incorrect values in first name (only latin letters and spaces allowed)
      ENDIF.

      IF lv_update_flag = ''.
        DATA(lv_2nd_lname_validation) = lo_data_validator->names_validation( input_last_name_2 ).
        IF lv_2nd_lname_validation = abap_false.
          lv_update_flag = 'X'.
          MESSAGE i007(zmsgclass). "MSG: Incorrect values in last name (only latin letters and spaces allowed)
        ENDIF.
      ENDIF.

      IF lv_update_flag = ''.
        DATA(lv_2nd_email_validation) = lo_data_validator->email_validation( input_email_2 ).
        IF lv_2nd_email_validation = abap_false.
          lv_update_flag = 'X'.
          MESSAGE i008(zmsgclass). "MSG: Incorrect values in email (letters.digits@lettersdigits.domain allowed)
        ENDIF.
      ENDIF.

      "### Checking if there is actually any changes to be updated - if not, process will stop here.
      IF lv_update_flag = ''.
        IF lwa_data_before-cust_fname = input_first_name_2 AND
           lwa_data_before-cust_lname = input_last_name_2 AND
           lwa_data_before-cust_email = input_email_2.
          lv_update_flag = 'X'.
          MESSAGE i009(zmsgclass). "MSG: No changes applied -> no update needed.
        ENDIF.
      ENDIF.

      "### If differences are present, then update will be done.
      IF lv_update_flag = ''.
        customer->update_customer( lv_first_name = input_first_name_2
                                   lv_last_name = input_last_name_2
                                   lv_email = input_email_2
                                   lv_cust_id = cust_id_output_2 ).
        MESSAGE i016(zmsgclass). "MSG: Update successful!

        "### Gathering data after update for changelog entries.
        DATA(lt_data_after) = VALUE zcust_details( cust_fname = input_first_name_2
                                                  cust_lname = input_last_name_2
                                                  cust_email = input_email_2 ).
        "### Comparing data before and after update - lt_differences will contain future changelog entries.
        lo_db_comparison->data_comparison( EXPORTING
                                             lt_data_before_update = lt_data_before
                                             lt_data_after_update = lt_data_after
                                           IMPORTING
                                              diff_table = DATA(lt_differences) ).

        lo_changelog->getting_data( user = CONV zcsyuname( sy-uname )
                                    date = sy-datum
                                    time = sy-uzeit
                                    customer = cust_id_output_2
                                    oper_type = 'MODIFY'
                                    lt_flds_values = lt_differences ).
        CLEAR lt_differences.
      ENDIF.

    WHEN 'UPDATE_ADRES_BTN'.

      "### getting data before update proceed to pass later to changelog updater
      DATA lt_other_data_before TYPE TABLE OF zcust_details.

      SELECT
      cust_gender,
      cust_phone,
      cust_postal_code,
      cust_street,
      cust_home_number,
      cust_aprtm_number,
      cust_city
      FROM zcust_details
      INTO CORRESPONDING FIELDS OF TABLE @lt_other_data_before
      WHERE cust_id = @cust_id_output_2.

      DATA(lwa_other_data_before) = lt_other_data_before[ 1 ].

      DATA(lt_adres_data_before_update) = VALUE zcust_details(  cust_gender = lwa_other_data_before-cust_gender
                                                                cust_phone = lwa_other_data_before-cust_phone
                                                                cust_postal_code = lwa_other_data_before-cust_postal_code
                                                                cust_city = lwa_other_data_before-cust_city
                                                                cust_street = lwa_other_data_before-cust_street
                                                                cust_home_number = lwa_other_data_before-cust_home_number
                                                                cust_aprtm_number = lwa_other_data_before-cust_aprtm_number
                                                                 ).

      "### validating if user's new data is correct
      DATA(lv_flag_other_details) = ''.

      IF postal_field IS NOT INITIAL.
        DATA(lv_postal_code_check) = lo_data_validator->postal_code_validation( postal_field ).
        IF lv_postal_code_check = abap_false.
          lv_flag_other_details = 'X'.
          MESSAGE i010(zmsgclass). "MSG: Wrong postal code (only letters, digitis, space and symbols .-/ possible)
        ENDIF.
      ENDIF.

      IF lv_flag_other_details = ''.
        IF city_field IS NOT INITIAL.
          DATA(lv_city_check) = lo_data_validator->city_validation( city_field ).
          IF lv_city_check = abap_false.
            lv_flag_other_details = 'X'.
            MESSAGE i010(zmsgclass). "MSG: Wrong postal code (only letters, digitis, space and symbols .-/ possible)
          ENDIF.
        ENDIF.
      ENDIF.

      IF lv_flag_other_details = ''.
        IF street_field IS NOT INITIAL.
          DATA(lv_street_check) = lo_data_validator->street_validation( street_field ).
          IF lv_street_check = abap_false.
            lv_flag_other_details = 'X'.
            MESSAGE i011(zmsgclass). "MSG: Wrong city name (only letters and space possible)
          ENDIF.
        ENDIF.
      ENDIF.

      IF lv_flag_other_details = ''.
        IF home_field IS NOT INITIAL.
          DATA(lv_home_check) = lo_data_validator->home_nr_validation( home_field ).
          IF lv_home_check = abap_false.
            lv_flag_other_details = 'X'.
            MESSAGE i012(zmsgclass). "MSG: Wrong value in home number (only numbers and letters possible)
          ENDIF.
        ENDIF.
      ENDIF.


      IF lv_flag_other_details = ''.
        IF apartment_field IS NOT INITIAL.
          DATA(lv_apartm_check) = lo_data_validator->apartm_nr_validation( apartment_field ).
          IF lv_apartm_check = abap_false.
            lv_flag_other_details = 'X'.
            MESSAGE i013(zmsgclass). "MSG: Wrong value in apartment number(only numbers and letters possible)
          ENDIF.
        ENDIF.
      ENDIF.

      IF lv_flag_other_details = ''.
        IF gender_field IS NOT INITIAL.
          DATA(lv_gender_check) = lo_data_validator->gender_validation( gender_field ).
          IF lv_gender_check = abap_false.
            lv_flag_other_details = 'X'.
            MESSAGE i014(zmsgclass). "MSG: Wrong value in gender field (only M - male and F - female possible)
          ENDIF.
        ENDIF.
      ENDIF.

      IF lv_flag_other_details = ''.
        IF phone_field IS NOT INITIAL.
          DATA(lv_phone_check) = lo_data_validator->phone_validation( phone_field ).
          IF lv_phone_check = abap_false.
            lv_flag_other_details = 'X'.
            MESSAGE i015(zmsgclass). "MSG: Wrong value in phone number (only digits and space possible)
          ENDIF.
        ENDIF.
      ENDIF.

      "### if new data is correct, program will check if there any actually any changes to be done
      IF lv_flag_other_details = ''.
        IF lwa_other_data_before-cust_gender = gender_field AND
           lwa_other_data_before-cust_phone = phone_field AND
           lwa_other_data_before-cust_postal_code = postal_field AND
           lwa_other_data_before-cust_city = city_field AND
           lwa_other_data_before-cust_street = street_field AND
           lwa_other_data_before-cust_home_number = home_field AND
           lwa_other_data_before-cust_aprtm_number = apartment_field.
          lv_flag_other_details = 'X'.
          MESSAGE i009(zmsgclass). "MSG: No changes applied -> no update needed.
        ENDIF.
      ENDIF.


      "### if data are correct and there are any differences, update will be executed
      IF lv_flag_other_details = ''.
        customer->update_adres( EXPORTING
                                   lv_gender = gender_field
                                   lv_phone = phone_field
                                   lv_postal_code = postal_field
                                   lv_city = city_field
                                   lv_street = street_field
                                   lv_home_nr = home_field
                                   lv_apartm_nr = apartment_field
                                   lv_cust_id = cust_id_output_2 ).
        MESSAGE i016(zmsgclass). "MSG: Update successful!

        "### preparing data after update for changelog updater


        DATA(lt_adres_data_after_update) = VALUE zcust_details(  cust_gender = gender_field
                                        cust_phone = phone_field
                                        cust_postal_code = postal_field
                                        cust_city = city_field
                                        cust_street = street_field
                                        cust_home_number = home_field
                                        cust_aprtm_number = apartment_field
                                       ).

        DATA(lo_db_comparison_2) = NEW zcl_db_comparison(  ).

        lo_db_comparison_2->data_comparison( EXPORTING
                                           lt_data_before_update = lt_adres_data_before_update
                                           lt_data_after_update = lt_adres_data_after_update
                                           IMPORTING
                                           diff_table = DATA(lt_adres_differences)  ).

        "### passing differences from compared data to changelog updater

        lo_changelog->getting_data( user = CONV zcsyuname( sy-uname )
                                    date = sy-datum
                                    time = sy-uzeit
                                    customer = cust_id_output_2
                                    oper_type = 'MODIFY'
                                    lt_flds_values = lt_adres_differences ).
        CLEAR lt_adres_differences.

      ENDIF.

    WHEN 'DELETE_BTN'.

      "### Getting data based on customer_id from screen (deleting user only possible after search).
      SELECT SINGLE *
      FROM zcust_details
      INTO @DATA(lwa_data_to_remove)
      WHERE cust_id = @cust_id_output_2.

      DATA lt_data_changes TYPE zcl_changelog_updater=>lt_flds_values.
      lt_data_changes = VALUE #( ( fld_name = 'First name' v_before = lwa_data_to_remove-cust_fname v_after = '' )
                                 ( fld_name = 'Last name' v_before = lwa_data_to_remove-cust_lname v_after = '' )
                                 ( fld_name = 'Email' v_before = lwa_data_to_remove-cust_email v_after = '' )
                                  ).

      "### Passing prepared data to changelog updater.
      lo_changelog->getting_data( user = CONV zcsyuname( sy-uname )
                                  date = sy-datum
                                  time = sy-uzeit
                                  customer = cust_id_output_2
                                  oper_type = 'DELETE'
                                  lt_flds_values = lt_data_changes ).

      "### Removing user.
      TRY.
          customer->delete_customer( lv_cust_id = cust_id_output_2 ).
          MESSAGE i004(zmsgclass). "MSG: User deleted succesfully
        CATCH cx_sy_open_sql_db INTO DATA(lcx_error).
          MESSAGE lcx_error->get_text( ) TYPE 'i'.
      ENDTRY.

      "### Clearing search result fields after removed user.
      CLEAR: input_first_name_2, input_last_name_2, input_email_2, cust_id_output_2.

    WHEN 'REFRESH'.

      "### Used only by ALV hotspot event to fill in the output_2 fields after hotspot click.
      DATA(lwa_clicked_data) = lo_alv_events->returning_data( ).

      input_first_name_2 = lwa_clicked_data-cust_fname.
      input_last_name_2 = lwa_clicked_data-cust_lname.
      cust_id_output_2 = lwa_clicked_data-cust_id.
      input_email_2 = lwa_clicked_data-cust_email.

    WHEN 'BACK'.

      LEAVE TO SCREEN 0.

    WHEN 'LOG_BTN'.

      CALL SCREEN 0200 STARTING AT 50 50.

    WHEN 'ADRES_BTN'.

      "### Showing/Hiding address fields and labels.
      lv_flag_invis = 'do_change'.
      LOOP AT SCREEN.
        IF screen-group1 = '111'.
          IF screen-invisible = 1 OR screen-active = 0.
            lv_flag_change = 'to visible'.
          ELSE.
            lv_flag_change = 'to invisible'.
          ENDIF.
        ENDIF.
      ENDLOOP.

      "### Filling in address fields with data.
      IF cust_id_output_2 IS NOT INITIAL.

        SELECT
        cust_gender,
        cust_phone,
        cust_postal_code,
        cust_street,
        cust_home_number,
        cust_aprtm_number,
        cust_city
        FROM zcust_details
        INTO TABLE @DATA(lt_adres_details)
        WHERE cust_id = @cust_id_output_2.

        DATA(lwa_adres_details) = lt_adres_details[ 1 ].

        postal_field = lwa_adres_details-cust_postal_code.
        city_field = lwa_adres_details-cust_city.
        street_field = lwa_adres_details-cust_street.
        home_field = lwa_adres_details-cust_home_number.
        apartment_field = lwa_adres_details-cust_aprtm_number.
        gender_field = lwa_adres_details-cust_gender.
        phone_field = lwa_adres_details-cust_phone.

      ENDIF.

  ENDCASE.


ENDMODULE.
