CLASS zcl_customer_data_validator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


  methods:
    names_validation
        importing
            name type zcname
        RETURNING VALUE(check_name) type abap_bool,

    email_validation
        importing
            email type zcemail
        RETURNING VALUE(check_email) type abap_bool.


  PROTECTED SECTION.
  PRIVATE SECTION.

  data: regex_name type string VALUE '^[A-Za-z ]+$',
        regex_email type string value '^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$'.



ENDCLASS.



CLASS zcl_customer_data_validator IMPLEMENTATION.

  METHOD names_validation.

    if cl_abap_matcher=>matches( pattern = regex_name text = name ).
        check_name = abap_true.
    else.
        check_name = abap_false.
    endif.

  ENDMETHOD.

  METHOD email_validation.

    if cl_abap_matcher=>matches( pattern = regex_email text = email ).
        check_email = abap_true.
    else.
        check_email = abap_false.
    endif.

  ENDMETHOD.

ENDCLASS.
