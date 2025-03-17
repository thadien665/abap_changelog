CLASS zcl_db_comparison DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    METHODS:
      data_comparison
        IMPORTING
          lt_data_before_update TYPE zcust_details
          lt_data_after_update  TYPE zcust_details
        EXPORTING
          diff_table            TYPE zcl_changelog_updater=>lt_flds_values.

  PROTECTED SECTION.
  PRIVATE SECTION.


    DATA: diff_table TYPE TABLE OF zcl_changelog_updater=>lty_flds_values.


ENDCLASS.



CLASS zcl_db_comparison IMPLEMENTATION.
  METHOD data_comparison.


    IF lt_data_before_update-cust_fname <> lt_data_after_update-cust_fname.
      APPEND VALUE #( fld_name = 'First name'
                                 v_before = lt_data_before_update-cust_fname
                                 v_after = lt_data_after_update-cust_fname )
                                 TO diff_table.
    ENDIF.

    IF lt_data_before_update-cust_lname <> lt_data_after_update-cust_lname.
      APPEND VALUE #( fld_name = 'Last name'
                                 v_before = lt_data_before_update-cust_lname
                                 v_after = lt_data_after_update-cust_lname )
                                 TO diff_table.
    ENDIF.

    IF lt_data_before_update-cust_email <> lt_data_after_update-cust_email.
      APPEND VALUE #( fld_name = 'Email'
                                 v_before = lt_data_before_update-cust_email
                                 v_after = lt_data_after_update-cust_email )
                                 TO diff_table.
    ENDIF.

    IF lt_data_before_update-cust_gender <> lt_data_after_update-cust_gender.
      APPEND VALUE #( fld_name = 'Gender'
                                 v_before = lt_data_before_update-cust_gender
                                 v_after = lt_data_after_update-cust_gender )
                                 TO diff_table.
    ENDIF.

    IF lt_data_before_update-cust_phone <> lt_data_after_update-cust_phone.
      APPEND VALUE #( fld_name = 'Phone number'
                                 v_before = lt_data_before_update-cust_phone
                                 v_after = lt_data_after_update-cust_phone )
                                 TO diff_table.
    ENDIF.

    IF lt_data_before_update-cust_postal_code <> lt_data_after_update-cust_postal_code.
      APPEND VALUE #( fld_name = 'Postal code'
                                 v_before = lt_data_before_update-cust_postal_code
                                 v_after = lt_data_after_update-cust_postal_code )
                                 TO diff_table.
    ENDIF.

    IF lt_data_before_update-cust_city <> lt_data_after_update-cust_city.
      APPEND VALUE #( fld_name = 'City'
                                 v_before = lt_data_before_update-cust_city
                                 v_after = lt_data_after_update-cust_city )
                                 TO diff_table.
    ENDIF.

    IF lt_data_before_update-cust_street <> lt_data_after_update-cust_street.
      APPEND VALUE #( fld_name = 'Street'
                                 v_before = lt_data_before_update-cust_street
                                 v_after = lt_data_after_update-cust_street )
                                 TO diff_table.
    ENDIF.

    IF lt_data_before_update-cust_home_number <> lt_data_after_update-cust_home_number.
      APPEND VALUE #( fld_name = 'Home number'
                                 v_before = lt_data_before_update-cust_home_number
                                 v_after = lt_data_after_update-cust_home_number )
                                 TO diff_table.
    ENDIF.

    IF lt_data_before_update-cust_aprtm_number <> lt_data_after_update-cust_aprtm_number.
      APPEND VALUE #( fld_name = 'Apartment number'
                                 v_before = lt_data_before_update-cust_aprtm_number
                                 v_after = lt_data_after_update-cust_aprtm_number )
                                 TO diff_table.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
