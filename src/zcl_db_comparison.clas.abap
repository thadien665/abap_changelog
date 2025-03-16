CLASS zcl_db_comparison DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    methods:
        data_comparison
            IMPORTING
                lt_data_before_update type zcust_details
                lt_data_after_update type zcust_details
            EXPORTING
                diff_table type zcl_changelog_updater=>lt_flds_values.

  PROTECTED SECTION.
  PRIVATE SECTION.


    data: diff_table type table of zcl_changelog_updater=>lty_flds_values.


ENDCLASS.



CLASS zcl_db_comparison IMPLEMENTATION.
  METHOD data_comparison.


    if lt_data_before_update-cust_fname <> lt_data_after_update-cust_fname.
        append value #( fld_name = 'First name'
                                   v_before = lt_data_before_update-cust_fname
                                   v_after = lt_data_after_update-cust_fname )
                                   to diff_table.
    endif.

    if lt_data_before_update-cust_lname <> lt_data_after_update-cust_lname.
        append value #( fld_name = 'Last name'
                                   v_before = lt_data_before_update-cust_lname
                                   v_after = lt_data_after_update-cust_lname )
                                   to diff_table.
    endif.

    if lt_data_before_update-cust_email <> lt_data_after_update-cust_email.
        append value #( fld_name = 'Email'
                                   v_before = lt_data_before_update-cust_email
                                   v_after = lt_data_after_update-cust_email )
                                   to diff_table.
    endif.

    if lt_data_before_update-cust_gender <> lt_data_after_update-cust_gender.
        append value #( fld_name = 'Gender'
                                   v_before = lt_data_before_update-cust_gender
                                   v_after = lt_data_after_update-cust_gender )
                                   to diff_table.
    endif.

    if lt_data_before_update-cust_phone <> lt_data_after_update-cust_phone.
        append value #( fld_name = 'Phone number'
                                   v_before = lt_data_before_update-cust_phone
                                   v_after = lt_data_after_update-cust_phone )
                                   to diff_table.
    endif.

    if lt_data_before_update-cust_postal_code <> lt_data_after_update-cust_postal_code.
        append value #( fld_name = 'Postal code'
                                   v_before = lt_data_before_update-cust_postal_code
                                   v_after = lt_data_after_update-cust_postal_code )
                                   to diff_table.
    endif.

    if lt_data_before_update-cust_city <> lt_data_after_update-cust_city.
        append value #( fld_name = 'City'
                                   v_before = lt_data_before_update-cust_city
                                   v_after = lt_data_after_update-cust_city )
                                   to diff_table.
    endif.

    if lt_data_before_update-cust_street <> lt_data_after_update-cust_street.
        append value #( fld_name = 'Street'
                                   v_before = lt_data_before_update-cust_street
                                   v_after = lt_data_after_update-cust_street )
                                   to diff_table.
    endif.

    if lt_data_before_update-cust_home_number <> lt_data_after_update-cust_home_number.
        append value #( fld_name = 'Home number'
                                   v_before = lt_data_before_update-cust_home_number
                                   v_after = lt_data_after_update-cust_home_number )
                                   to diff_table.
    endif.

    if lt_data_before_update-cust_aprtm_number <> lt_data_after_update-cust_aprtm_number.
        append value #( fld_name = 'Apartment number'
                                   v_before = lt_data_before_update-cust_aprtm_number
                                   v_after = lt_data_after_update-cust_aprtm_number )
                                   to diff_table.
    endif.

  ENDMETHOD.

ENDCLASS.
