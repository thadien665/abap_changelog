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
        RETURNING VALUE(check_email) type abap_bool,

    postal_code_validation
        importing
            postal_code type zcpostalcode
        RETURNING VALUE(check_postal_code) type abap_bool,

    city_validation
        importing
            city type zccity
        RETURNING VALUE(check_city) type abap_bool,

    street_validation
        importing
            street type zcstreet
        RETURNING VALUE(check_street) type abap_bool,

    home_nr_validation
        importing
            home_nr type zchnumber
        RETURNING VALUE(check_home_nr) type abap_bool,

    apartm_nr_validation
        importing
            apartm_nr type zcanumber
        RETURNING VALUE(check_apartm_nr) type abap_bool,

    phone_validation
        importing
            phone type zcphone
        RETURNING VALUE(check_phone) type abap_bool,

    gender_validation
        importing
            gender type zcgender
        RETURNING VALUE(check_gender) type abap_bool.


  PROTECTED SECTION.
  PRIVATE SECTION.

  data: regex_name type string VALUE '^[A-Za-z ]+$',
        regex_email type string value '^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$',
        regex_postal_code type string value '^[A-Za-z0-9\.\-\/ ]+$',
        regex_phone type string value '^[0-9 ]+$',
        regex_home_nr type string value '^[0-9A-Za-z]+$',
        regex_street type string value '^[A-Za-z0-9\.\- ]+$',
        gender_options type string value '[MF]'.


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

  METHOD apartm_nr_validation.

    data(regex_apartm_nr) = regex_home_nr.

    if cl_abap_matcher=>matches( pattern = regex_apartm_nr text = apartm_nr ).
        check_apartm_nr = abap_true.
    else.
        check_apartm_nr = abap_false.
    endif.

  ENDMETHOD.

  METHOD city_validation.

    data(regex_city) = regex_name.

    if cl_abap_matcher=>matches( pattern = regex_city text = city ).
        check_city = abap_true.
    else.
        check_city = abap_false.
    endif.

  ENDMETHOD.

  METHOD gender_validation.

    if cl_abap_matcher=>matches( pattern = gender_options text = gender ).
        check_gender = abap_true.
    else.
        check_gender = abap_false.
    endif.

  ENDMETHOD.

  METHOD home_nr_validation.

    if cl_abap_matcher=>matches( pattern = regex_home_nr text = home_nr ).
        check_home_nr = abap_true.
    else.
        check_home_nr = abap_false.
    endif.

  ENDMETHOD.

  METHOD phone_validation.

    if cl_abap_matcher=>matches( pattern = regex_phone text = phone ).
        check_phone = abap_true.
    else.
        check_phone = abap_false.
    endif.

  ENDMETHOD.

  METHOD postal_code_validation.

    if cl_abap_matcher=>matches( pattern = regex_postal_code text = postal_code ).
        check_postal_code = abap_true.
    else.
        check_postal_code = abap_false.
    endif.

  ENDMETHOD.

  METHOD street_validation.

    if cl_abap_matcher=>matches( pattern = regex_street text = street ).
        check_street = abap_true.
    else.
        check_street = abap_false.
    endif.

  ENDMETHOD.

ENDCLASS.
