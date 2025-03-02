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
*### cust_id_output - customer's ID (not to be modified by user)

  DATA: input_first_name TYPE zcname,
        input_last_name  TYPE zcname,
        input_email      TYPE zcemail,
        cust_id_output   TYPE zcid.

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

*### Declaration of actions for each customer modification option:
*### CLEAR_BTN - to clear all fields so user doesn't have to clear all manually
*### CREATE_BTN - new customer creation
*### SEARCH_BTN - searching for customer
*### UPDATE_BTN - updating data of customer
*### DELETE_BTN - removing customer.

  CASE sy-ucomm.

    WHEN 'CLEAR_BTN'.

      CLEAR: input_first_name, input_last_name, input_email, cust_id_output.

    WHEN 'CREATE_BTN'.

      "### All 3 values are mandatory to provide ###"
      IF input_first_name IS INITIAL OR input_last_name IS INITIAL OR input_email IS INITIAL.
        MESSAGE i002(zmsgclass).
      ELSE.
        customer->create_customer( lv_first_name = input_first_name
                                   lv_last_name = input_last_name
                                   lv_email = input_email ).

        MESSAGE i001(zmsgclass).
        CLEAR: input_first_name, input_last_name, input_email.
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

      customer->update_customer( lv_first_name = input_first_name_2
                                 lv_last_name = input_last_name_2
                                 lv_email = input_email_2
                                 lv_cust_id = CUST_ID_OUTPUT_2 ).

    WHEN 'DELETE_BTN'.

      TRY.
          customer->delete_customer( lv_cust_id = cust_id_output ).
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

    endcase.


ENDMODULE.
