*----------------------------------------------------------------------*
***INCLUDE ZCLIENT_MANAGEMENT_USER_COMI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

*### Data declarations for searching fields:
*### input_first_name - customer's first name
*### input_last_name - customer's last name
*### input_email - customer's email

  DATA: input_first_name TYPE zcname,
        input_last_name  TYPE zcname,
        input_email      TYPE zcemail.

  data: POSTAL_FIELD type zcpostalcode,
        CITY_FIELD type zccity,
        STREET_FIELD type zcstreet,
        HOME_FIELD type zchnumber,
        APARTMENT_FIELD type zcanumber,
        GENDER_FIELD type zcgender,
        PHONE_FIELD type zcphone.

*  Data: INPUT_FIRST_NAME_2 type zcname,
*        INPUT_LAST_NAME_2 type zcname,
*        INPUT_EMAIL_2 type zcemail,
*        CUST_ID_OUTPUT_2 type zcid.

*### ALV data types declarations ###*

  DATA lo_alv_grid TYPE REF TO cl_gui_alv_grid.
  DATA lo_alv_container TYPE REF TO cl_gui_custom_container.
  DATA lt_fieldcatalog TYPE lvc_t_fcat.
  data: gs_layout type lvc_s_layo.
        gs_layout-no_toolbar = 'X'.


  lt_fieldcatalog = VALUE #(
      ( fieldname = 'cust_id' col_pos = 0 scrtext_m = 'id' hotspot = 'X' )
      ( fieldname = 'cust_fname' col_pos = 1 scrtext_m = 'first name' )
      ( fieldname = 'cust_lname' col_pos = 2 scrtext_m = 'last name')
      ( fieldname = 'cust_email' col_pos = 3 scrtext_m = 'email' )
   ).

*### Table used to keep data received from customer search method, with data for ALV ###*

  DATA lt_imported_cust_data TYPE zcl_customer=>ls_cust_data.

*### Creating new object for customer modification methods (assigned below to buttons) ###*

  DATA(customer) = NEW zcl_customer(  ).

  data(lo_changelog) = new zcl_changelog_updater( ).
  data(lo_data_validator) = new zcl_customer_data_validator(  ).
  data lv_create_flag type string value ''.
  data lv_update_flag type string value ''.


*### Declaration of actions for each customer modification option:
*### CLEAR_BTN - to clear all fields so user doesn't have to clear all manually
*### CREATE_BTN - new customer creation
*### SEARCH_BTN - searching for customer
*### UPDATE_BTN - updating data of customer
*### DELETE_BTN - removing customer.

  CASE sy-ucomm.

    WHEN 'CLEAR_BTN'.

      CLEAR: input_first_name, input_last_name, input_email.

    WHEN 'CREATE_BTN'.

      "### All 3 values are mandatory to provide ###"
      IF input_first_name IS INITIAL OR input_last_name IS INITIAL OR input_email IS INITIAL.
        lv_create_flag = 'X'.
        MESSAGE i002(zmsgclass).
      ELSE.
        lv_create_flag = ''.
      endif.

      if lv_create_flag = ''.
        data(lv_fname_validation) = lo_data_validator->names_validation( exporting
                                                                            name = input_first_name
                                                                        ).
        if lv_fname_validation = abap_false.
            lv_create_flag = 'X'.
            MESSAGE i006(zmsgclass).
        else.
            lv_create_flag = ''.
        endif.
      endif.

      if lv_create_flag = ''.
        data(lv_lname_validation) = lo_data_validator->names_validation( exporting
                                                                            name = input_last_name
                                                                        ).
        if lv_lname_validation = abap_false.
            lv_create_flag = 'X'.
            MESSAGE i007(zmsgclass).
        else.
            lv_create_flag = ''.
        endif.
      endif.

      if lv_create_flag = ''.
        data(lv_email_validation) = lo_data_validator->email_validation( exporting
                                                                            email = input_email
                                                                        ).
        if lv_email_validation = abap_false.
            lv_create_flag = 'X'.
            MESSAGE i008(zmsgclass).
        else.
            lv_create_flag = ''.
        endif.

      endif.

      if lv_create_flag = ''.
        customer->create_customer( EXPORTING
                                   lv_first_name = input_first_name
                                   lv_last_name = input_last_name
                                   lv_email = input_email
                                   IMPORTING
                                   status = data(create_status)
                                   customer_id = data(customer_id) ).
          if create_status = abap_true.
            data lt_changelog_data_1 type  zcl_changelog_updater=>lt_flds_values.

            lt_changelog_data_1 = value #( ( fld_name = 'First name' v_before = '' v_after = input_first_name )
                                         ( fld_name = 'Last name' v_before = '' v_after = input_last_name )
                                         ( fld_name = 'Email' v_before = '' v_after = input_email )
                                         ( fld_name = 'Customer id' v_before = '' v_after = customer_id )
                                       ).

            lo_changelog->getting_data( user = conv ZCSYUNAME( sy-uname )
                                        date = sy-datum
                                        time = sy-uzeit
                                        customer = customer_id
                                        oper_type = 'CREATE'
                                        lt_flds_values = lt_changelog_data_1 ).

            MESSAGE i001(zmsgclass).

            CLEAR: input_first_name, input_last_name, input_email.
           else.
            MESSAGE i005(zmsgclass).
           endif.
      ENDIF.

    WHEN 'SEARCH_BTN'.

      IF input_first_name IS INITIAL AND input_last_name IS INITIAL AND input_email IS INITIAL.
        MESSAGE s003(zmsgclass).
      ENDIF.

      IF lo_alv_grid IS INITIAL.
        lo_alv_container = NEW cl_gui_custom_container( 'SUBSCREEN_1' ).
        lo_alv_grid = NEW cl_gui_alv_grid( lo_alv_container ).
        set HANDLER lo_alv_events->hotspot for lo_alv_grid.

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

      lv_update_flag = ''.
      data(lo_db_comparison) = new zcl_db_comparison(  ).

      data(lwa_data_before) = lo_alv_events->returning_data(  ).

      data(lt_data_before) = value zcust_details( cust_fname = lwa_data_before-cust_fname
                                                cust_lname = lwa_data_before-cust_lname
                                                cust_email = lwa_data_before-cust_email ).

      data(lv_2nd_fname_validation) = lo_data_validator->names_validation( input_first_name_2 ).
      if lv_2nd_fname_validation = abap_false.
        lv_update_flag = 'X'.
        MESSAGE i006(zmsgclass).
      endif.

      if lv_update_flag = ''.
        data(lv_2nd_lname_validation) = lo_data_validator->names_validation( input_last_name_2 ).
        if lv_2nd_lname_validation = abap_false.
           lv_update_flag = 'X'.
           MESSAGE i007(zmsgclass).
        endif.
      endif.

      if lv_update_flag = ''.
        data(lv_2nd_email_validation) = lo_data_validator->email_validation( input_email_2 ).
        if lv_2nd_email_validation = abap_false.
            lv_update_flag = 'X'.
            MESSAGE i008(zmsgclass).
        endif.
      endif.

      if lv_update_flag = ''.
        if lwa_data_before-cust_fname = input_first_name_2 and
           lwa_data_before-cust_lname = input_last_name_2 and
           lwa_data_before-cust_email = input_email_2.
        lv_update_flag = 'X'.
        MESSAGE i009(zmsgclass).
        endif.
      endif.

      if lv_update_flag = ''.
      customer->update_customer( lv_first_name = input_first_name_2
                                 lv_last_name = input_last_name_2
                                 lv_email = input_email_2
                                 lv_cust_id = CUST_ID_OUTPUT_2 ).

      data(lt_data_after) = value zcust_details( cust_fname = input_first_name_2
                                                cust_lname = input_last_name_2
                                                cust_email = input_email_2 ).

      lo_db_comparison->data_comparison( exporting
                                           lt_data_before_update = lt_data_before
                                           lt_data_after_update = lt_data_after
                                         importing
                                            diff_table = data(lt_differences) ).

      lo_changelog->getting_data( user = conv ZCSYUNAME( sy-uname )
                                  date = sy-datum
                                  time = sy-uzeit
                                  customer = CUST_ID_OUTPUT_2
                                  oper_type = 'MODIFY'
                                  lt_flds_values = lt_differences ).
      endif.

      "### checking if user entered any other details. If not, this block with other details will be skipped.
      if POSTAL_FIELD is not INITIAL or
         CITY_FIELD is not initial or
         STREET_FIELD is not initial or
         HOME_FIELD is not initial or
         APARTMENT_FIELD is not initial or
         GENDER_FIELD is not initial or
         PHONE_FIELD is not initial.


      "### getting data before update proceed to pass later to changelog updater
        data lt_other_data_before type table of zcust_details.

          select
          cust_gender,
          cust_phone,
          cust_postal_code,
          cust_street,
          cust_home_number,
          cust_aprtm_number
          from zcust_details
          into table @lt_other_data_before
          where cust_id = @cust_id_output_2.

          data(lwa_other_data_before) = lt_other_data_before[ 1 ].

      "### validating if user's new data is correct
        data lv_flag_other_details type string value ''.

        if POSTAL_FIELD is not initial.
            data(lv_postal_code_check) = lo_data_validator->postal_code_validation( POSTAL_FIELD ).
            if lv_postal_code_check = abap_false.
                lv_flag_other_details = 'X'.
                MESSAGE i010(zmsgclass).
            endif.
        endif.

        if lv_flag_other_details = ''.
            if CITY_FIELD is not initial.
                data(lv_city_check) = lo_data_validator->city_validation( CITY_FIELD ).
                    if lv_city_check = abap_false.
                        lv_flag_other_details = 'X'.
                        MESSAGE i010(zmsgclass).
                    endif.
            endif.
        endif.

        if lv_flag_other_details = ''.
            if STREET_FIELD is not initial.
                data(lv_street_check) = lo_data_validator->street_validation( STREET_FIELD ).
                    if lv_street_check = abap_false.
                        lv_flag_other_details = 'X'.
                        MESSAGE i011(zmsgclass).
                    endif.
            endif.
        endif.

        if lv_flag_other_details = ''.
            if HOME_FIELD is not initial.
                data(lv_home_check) = lo_data_validator->home_nr_validation( HOME_FIELD ).
                    if lv_home_check = abap_false.
                        lv_flag_other_details = 'X'.
                        MESSAGE i012(zmsgclass).
                    endif.
            endif.
        endif.


        if lv_flag_other_details = ''.
            if APARTMENT_FIELD is not initial.
                data(lv_apartm_check) = lo_data_validator->apartm_nr_validation( APARTMENT_FIELD ).
                    if lv_apartm_check = abap_false.
                        lv_flag_other_details = 'X'.
                        MESSAGE i013(zmsgclass).
                    endif.
            endif.
        endif.

        if lv_flag_other_details = ''.
            if GENDER_FIELD is not initial.
                data(lv_gender_check) = lo_data_validator->gender_validation( GENDER_FIELD ).
                    if lv_gender_check = abap_false.
                        lv_flag_other_details = 'X'.
                        MESSAGE i014(zmsgclass).
                    endif.
            endif.
        endif.

        if lv_flag_other_details = ''.
            if PHONE_FIELD is not initial.
                data(lv_phone_check) = lo_data_validator->phone_validation( PHONE_FIELD ).
                    if lv_phone_check = abap_false.
                        lv_flag_other_details = 'X'.
                        MESSAGE i015(zmsgclass).
                    endif.
            endif.
        endif.

      "### if new data is correct, program will check if there any actually any changes to be done
      if lv_flag_other_details = ''.
          if lwa_other_data_before-cust_gender = GENDER_FIELD and
             lwa_other_data_before-cust_phone = phone_field and
             lwa_other_data_before-cust_postal_code = postal_field and
             lwa_other_data_before-cust_city = city_field and
             lwa_other_data_before-cust_street = street_field and
             lwa_other_data_before-cust_home_number = home_field and
             lwa_other_data_before-cust_aprtm_number = apartment_field.
             lv_update_flag = 'X'.
             MESSAGE i009(zmsgclass).
          endif.
      endif.


      "### if data are correct and there are any differences, update will be executed
      if lv_flag_other_details = ''.
        customer->update_customer( EXPORTING
                                   lv_gender = GENDER_FIELD
                                   lv_phone = phone_field
                                   lv_postal_code = postal_field
                                   lv_city = city_field
                                   lv_street = street_field
                                   lv_home_nr = home_field
                                   lv_apartm_nr = apartment_field
                                   lv_cust_id = cust_id_output_2 ).
      endif.




      endif.

    WHEN 'DELETE_BTN'.

      select single *
      from zcust_details
      into @data(lwa_data_to_remove)
      where cust_id = @cust_id_output_2.

      data lt_data_changes type zcl_changelog_updater=>lt_flds_values.
      lt_data_changes = value #( ( fld_name = 'First name' v_before = lwa_data_to_remove-cust_fname v_after = '' )
                                 ( fld_name = 'Last name' v_before = lwa_data_to_remove-cust_lname v_after = '' )
                                 ( fld_name = 'Email' v_before = lwa_data_to_remove-cust_email v_after = '' )
                                  ).

      lo_changelog->getting_data( user = conv ZCSYUNAME( sy-uname )
                                  date = sy-datum
                                  time = sy-uzeit
                                  customer = cust_id_output_2
                                  oper_type = 'DELETE'
                                  lt_flds_values = lt_data_changes ).

      TRY.
          customer->delete_customer( lv_cust_id = cust_id_output_2 ).
          MESSAGE i004(zmsgclass).
        CATCH cx_sy_open_sql_db INTO DATA(lcx_error).
          MESSAGE lcx_error->get_text( ) TYPE 'i'.
      ENDTRY.

    WHEN 'REFRESH'.

        data(lwa_clicked_data) = lo_alv_events->returning_data( ).

        INPUT_FIRST_NAME_2 = lwa_clicked_data-cust_fname.
        input_last_name_2 = lwa_clicked_data-cust_lname.
        CUST_ID_OUTPUT_2 = lwa_clicked_data-cust_id.
        INPUT_EMAIL_2 = lwa_clicked_data-cust_email.

    WHEN 'BACK'.

        leave to screen 0.

    WHEN 'LOG_BTN'.

        call screen 0200 STARTING AT 50 50.

    endcase.


ENDMODULE.
