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
          status type abap_bool
          customer_id type zcid,

      search_cusomer
        IMPORTING
          lv_first_name    TYPE zcname
          lv_last_name     TYPE zcname
          lv_email         TYPE zcemail
        EXPORTING
          lt_customer_data TYPE ls_cust_data,

      update_customer
        IMPORTING
          lv_first_name TYPE zcname optional
          lv_last_name  TYPE zcname optional
          lv_email      TYPE zcemail optional
          lv_cust_id    TYPE zcid optional,

      update_adres
        importing
          lv_postal_code type zcpostalcode OPTIONAL
          lv_city       type zccity optional
          lv_street     type zcstreet optional
          lv_home_nr    type zchnumber optional
          lv_apartm_nr  type zcanumber optional
          lv_phone      type zcphone optional
          lv_gender     type zcgender optional
          lv_cust_id    TYPE zcid optional,

      delete_customer
        IMPORTING
          lv_cust_id TYPE zcid.

    data: lo_changelog type ref to zcl_changelog_updater,
          lt_changelog_fld_values type zcl_changelog_updater=>lt_flds_values.



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
    customer_id = lv_new_customer-cust_id.

    INSERT zcust_details FROM lv_new_customer.
    COMMIT WORK.
    status = abap_true.

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

  method update_adres.

    data: lt_set_builder type table of string,
          lwa_set_builder type string.

*    if lv_postal_code is not initial or
*       lv_city is not initial or
*       lv_street is not initial or
*       lv_home_nr is not initial or
*       lv_apartm_nr is not initial or
*       lv_phone is not initial or
*       lv_gender is not initial.


*        if lv_postal_code is not initial.
            APPEND |cust_postal_code = @lv_postal_code| TO lt_set_builder.
*        endif.

*        if lv_city is not initial.
            APPEND |cust_city = @lv_city| TO lt_set_builder.
*        endif.

*        if lv_street is not initial.
            APPEND |cust_street = @lv_street| TO lt_set_builder.
*        endif.

*        if lv_home_nr is not initial.
            APPEND |cust_home_number = @lv_home_nr| TO lt_set_builder.
*        endif.

*        if lv_apartm_nr is not initial.
            APPEND |cust_aprtm_number = @lv_apartm_nr| TO lt_set_builder.
*        endif.

*        if lv_phone is not initial.
            APPEND |cust_phone = @lv_phone| TO lt_set_builder.
*        endif.

*        if lv_gender is not initial.
            APPEND |cust_gender = @lv_gender| TO lt_set_builder.
*        endif.

        if lines( lt_set_builder ) = 1.
            lwa_set_builder = lt_set_builder[ 1 ].
        else.
            CONCATENATE LINES OF lt_set_builder INTO lwa_set_builder SEPARATED BY ', '.
        endif.

        UPDATE zcust_details
        SET (lwa_set_builder)
        WHERE cust_id = @lv_cust_id.
        COMMIT WORK.

*    endif.

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
