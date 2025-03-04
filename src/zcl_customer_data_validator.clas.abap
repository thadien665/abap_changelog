CLASS zcl_customer_data_validator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


  methods:
    names_validation
        importing
            name type zcname
        RETURNING VALUE(check) type abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.

  data acceptable_letters_and_space type string VALUE '^[A-Za-z ]+$'.



ENDCLASS.



CLASS zcl_customer_data_validator IMPLEMENTATION.

  METHOD names_validation.

    if cl_abap_matcher=>matches( pattern = acceptable_letters_and_space text = name ).
        check = abap_true.
    else.
        check = abap_false.
    endif.

  ENDMETHOD.

ENDCLASS.
