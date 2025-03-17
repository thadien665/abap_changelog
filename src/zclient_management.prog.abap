*&---------------------------------------------------------------------*
*& Modulpool ZCLIENT_MANAGEMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM zclient_management.

DATA: input_first_name_2 TYPE zcname,
      input_last_name_2  TYPE zcname,
      input_email_2      TYPE zcemail,
      cust_id_output_2   TYPE zcid.

*### Data declarations for searching fields:
*### input_first_name - customer's first name
*### input_last_name - customer's last name
*### input_email - customer's email

DATA: input_first_name TYPE zcname,
      input_last_name  TYPE zcname,
      input_email      TYPE zcemail.

*### Data declarations for address fields.

DATA: postal_field    TYPE zcpostalcode,
      city_field      TYPE zccity,
      street_field    TYPE zcstreet,
      home_field      TYPE zchnumber,
      apartment_field TYPE zcanumber,
      gender_field    TYPE zcgender,
      phone_field     TYPE zcphone.

*### Data declaration for ALV object, container and fieldcatalog + other objects used in PAI.
DATA: lo_alv_events     TYPE REF TO zcl_alv_events,
      lo_alv_grid       TYPE REF TO cl_gui_alv_grid,
      lo_alv_container  TYPE REF TO cl_gui_custom_container,
      lt_fieldcatalog   TYPE lvc_t_fcat,
      gs_layout         TYPE lvc_s_layo,
      customer          TYPE REF TO zcl_customer,
      lo_changelog      TYPE REF TO zcl_changelog_updater,
      lo_data_validator TYPE REF TO zcl_customer_data_validator.

*### Table used to keep data received from customer search method, with data for ALV ###*

DATA lt_imported_cust_data TYPE zcl_customer=>ls_cust_data.

*### 'Flag' variables used during PAI uptions.
DATA lv_create_flag TYPE string VALUE ''.
DATA lv_update_flag TYPE string VALUE ''.
DATA lv_flag_invis TYPE string VALUE ''.
DATA lv_flag_change TYPE string.

INITIALIZATION.
  CREATE OBJECT: lo_alv_events.

LOAD-OF-PROGRAM.
  CREATE OBJECT: customer, lo_changelog, lo_data_validator.

*### Removing toolbar from ALV search results table.
  gs_layout-no_toolbar = 'X'.

*### Setting up ALV searching result table design.
  lt_fieldcatalog = VALUE #(
      ( fieldname = 'cust_id' col_pos = 0 scrtext_m = 'id' hotspot = 'X' )
      ( fieldname = 'cust_fname' col_pos = 1 scrtext_m = 'first name' )
      ( fieldname = 'cust_lname' col_pos = 2 scrtext_m = 'last name')
      ( fieldname = 'cust_email' col_pos = 3 scrtext_m = 'email' )
   ).

  INCLUDE zclient_management_user_comi01.

  INCLUDE zclient_management_status_0o02.

  INCLUDE zclient_management_status_0o03.

  INCLUDE zclient_management_user_comi02.
