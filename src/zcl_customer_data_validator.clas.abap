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
ENDCLASS.



CLASS zcl_customer_data_validator IMPLEMENTATION.

  METHOD names_validation.

    data(regex) = '[A-Za-zÀ-Ÿà-ÿ\-\ \'']'.

    if name CS regex.
        check = abap_true.
    else.
        check = abap_false.
    endif.

  ENDMETHOD.

ENDCLASS.
