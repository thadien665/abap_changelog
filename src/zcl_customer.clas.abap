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
          lv_email      TYPE zcemail,

      search_cusomer
        IMPORTING
          lv_first_name    TYPE zcname
          lv_last_name     TYPE zcname
          lv_email         TYPE zcemail
        EXPORTING
          lt_customer_data TYPE ls_cust_data,
      update_customer
        IMPORTING
          lv_first_name TYPE zcname
          lv_last_name  TYPE zcname
          lv_email      TYPE zcemail
          lv_cust_id    TYPE zcid,

      delete_customer
        IMPORTING
          lv_cust_id TYPE zcid.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_customer IMPLEMENTATION.
  METHOD create_customer.

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

    INSERT zcust_details FROM lv_new_customer.
    COMMIT WORK.

  ENDMETHOD.


  METHOD search_cusomer.

    DATA lv_where_builder TYPE string.
    DATA lt_builder_parts TYPE TABLE OF string.


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
