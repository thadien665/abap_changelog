CLASS zcl_customer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ls_data,
             cust_id    TYPE zcid,
             cust_fname TYPE zcname,
             cust_lname TYPE zcname,
             cust_email TYPE zcemail,
           END OF ls_data.

    TYPES: ls_cust_data TYPE TABLE OF ls_data.

    METHODS:
      create_customer
        IMPORTING
          lv_first_name TYPE zcname
          lv_last_name  TYPE zcname
          lv_email      TYPE zcemail
        EXPORTING
          status        TYPE abap_bool
          customer_id   TYPE zcid,

      search_cusomer
        IMPORTING
          lv_first_name    TYPE zcname
          lv_last_name     TYPE zcname
          lv_email         TYPE zcemail
        EXPORTING
          lt_customer_data TYPE ls_cust_data,

      update_customer
        IMPORTING
          lv_first_name TYPE zcname OPTIONAL
          lv_last_name  TYPE zcname OPTIONAL
          lv_email      TYPE zcemail OPTIONAL
          lv_cust_id    TYPE zcid OPTIONAL,

      update_adres
        IMPORTING
          lv_postal_code TYPE zcpostalcode OPTIONAL
          lv_city        TYPE zccity OPTIONAL
          lv_street      TYPE zcstreet OPTIONAL
          lv_home_nr     TYPE zchnumber OPTIONAL
          lv_apartm_nr   TYPE zcanumber OPTIONAL
          lv_phone       TYPE zcphone OPTIONAL
          lv_gender      TYPE zcgender OPTIONAL
          lv_cust_id     TYPE zcid OPTIONAL,

      delete_customer
        IMPORTING
          lv_cust_id TYPE zcid.

    DATA: lo_changelog            TYPE REF TO zcl_changelog_updater,
          lt_changelog_fld_values TYPE zcl_changelog_updater=>lt_flds_values.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_customer IMPLEMENTATION.
  METHOD create_customer.

    "### After user's removal, his customer_id is removed from table and at the same time
    "### added to storage 'zcust_id_storage'. It was one of two ways possible in the program.
    "### Second solution was based on looping at the customer's table every time - which, from
    "### optimization point, could be heavier than storage solution.
    "### ZCUST_DETAILS DDIC table (on which this program works) is designed for max of around
    "### 30k users, so solution choice is very subjective.
    "### If storage contains any row (is not empty), create process will take first available
    "### ID from storage.
    "### If storage is empty, create process will take highest possible ID from
    "### zcust_details + 1.

    DATA: lv_new_customer TYPE zcust_details,
          lv_int_cust_id  TYPE i.

    SELECT MIN( customer_id )
    FROM zcust_id_storage
    INTO @DATA(lv_max_existing_id).

    IF lv_max_existing_id IS INITIAL.

      SELECT MAX( cust_id )
      FROM zcust_details
      INTO lv_max_existing_id.

      lv_int_cust_id = lv_max_existing_id + 1.
      lv_new_customer-cust_id = lv_int_cust_id.

    ELSE.
      lv_new_customer-cust_id = lv_max_existing_id.
      DELETE FROM zcust_id_storage WHERE customer_id = lv_max_existing_id.
    ENDIF.

    lv_new_customer-cust_fname = lv_first_name.
    lv_new_customer-cust_lname = lv_last_name.
    lv_new_customer-cust_email = lv_email.
    customer_id = lv_new_customer-cust_id.

    INSERT zcust_details FROM lv_new_customer.
    COMMIT WORK.
    status = abap_true.

  ENDMETHOD.


  METHOD search_cusomer.

    DATA lv_where_builder TYPE string.
    DATA lt_builder_parts TYPE TABLE OF string.

    "### Because searching could be performed on at least one data (one of names or only email)
    "### the WHERE clause is created dynamically:
    "### based on appending rows to table -> concatenating all rows to one string.
    IF lv_first_name IS NOT INITIAL.
      APPEND |cust_fname = @lv_first_name| TO lt_builder_parts.
    ENDIF.
    IF lv_last_name IS NOT INITIAL.
      APPEND |cust_lname = @lv_last_name| TO lt_builder_parts.
    ENDIF.
    IF lv_email IS NOT INITIAL.
      APPEND |cust_email = @lv_email| TO lt_builder_parts.
    ENDIF.

    IF lines( lt_builder_parts ) = 1.
      lv_where_builder = lt_builder_parts[ 1 ].
    ELSE.
      CONCATENATE LINES OF lt_builder_parts INTO lv_where_builder SEPARATED BY ' AND '.
    ENDIF.

    SELECT cust_id, cust_fname, cust_lname, cust_email
    FROM zcust_details
    INTO TABLE @lt_customer_data
    WHERE (lv_where_builder).

  ENDMETHOD.

  METHOD update_customer.

    UPDATE zcust_details
    SET cust_fname = @lv_first_name, cust_lname = @lv_last_name, cust_email = @lv_email
    WHERE cust_id = @lv_cust_id.
    COMMIT WORK.

  ENDMETHOD.

  METHOD update_adres.

    DATA: lt_set_builder  TYPE TABLE OF string,
          lwa_set_builder TYPE string.

    "### Update address function is accepting removal of some fields (f.e. when user want
    "### to remove phone number from customer's account), so we are not using appends, but creating
    "### table from strings with statements.
    "### If we would like to change the process and block user from removing data, then we can apply
    "### 'append' solution from create function.
    lt_set_builder = VALUE #( ( |cust_postal_code = @lv_postal_code| )
                              ( |cust_city = @lv_city| )
                              ( |cust_street = @lv_street| )
                              ( |cust_home_number = @lv_home_nr| )
                              ( |cust_aprtm_number = @lv_apartm_nr| )
                              ( |cust_phone = @lv_phone| )
                              ( |cust_gender = @lv_gender| )
                               ).

    CONCATENATE LINES OF lt_set_builder INTO lwa_set_builder SEPARATED BY ', '.

    UPDATE zcust_details
    SET (lwa_set_builder)
    WHERE cust_id = @lv_cust_id.
    COMMIT WORK.

  ENDMETHOD.

  METHOD delete_customer.

    DATA lwa_removed_id TYPE zcust_id_storage.


    IF lv_cust_id IS NOT INITIAL.

      lwa_removed_id-customer_id = lv_cust_id.
      INSERT INTO zcust_id_storage VALUES lwa_removed_id.

      DELETE FROM zcust_details WHERE cust_id = lv_cust_id.
      COMMIT WORK.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
