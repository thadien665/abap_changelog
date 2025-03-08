*"* use this source file for your ABAP unit test classes

class name_Validation_1 definition for testing
  duration short
  risk level harmless.

  private section.
    data f_Cut type ref to zcl_Customer_Data_Validator.


    methods: names_Validation for testing,
             email_validation for testing,
             phone_validation for testing,
             gender_validation for testing,
             postal_code_validation for testing,
             city_validation for testing,
             street_validation for testing,
             home_nr_validation for testing,
             apartm_nr_validation for testing.

endclass.


class name_Validation_1 implementation.

  method names_Validation.

    f_cut = new zcl_Customer_Data_Validator(  ).

    data(check) = f_cut->names_validation( name = 'anna maria' ).

    cl_Abap_Unit_Assert=>assert_Equals(
          act   = check
          exp   = abap_true
        ).

  endmethod.

  method email_validation.

    f_cut = new zcl_Customer_Data_Validator(  ).

    data(check) = f_cut->email_validation( email = 'anna.maria456@gmail.com' ).

    cl_Abap_Unit_Assert=>assert_Equals(
          act   = check
          exp   = abap_true
        ).

  endmethod.

  method apartm_nr_validation.

    f_cut = new zcl_Customer_Data_Validator(  ).

    data(check) = f_cut->apartm_nr_validation( apartm_nr = '99aA' ).

    cl_Abap_Unit_Assert=>assert_Equals(
          act   = check
          exp   = abap_true
        ).

  endmethod.

  method city_validation.

    f_cut = new zcl_Customer_Data_Validator(  ).

    data(check) = f_cut->city_validation( city = 'Manchester East' ).

    cl_Abap_Unit_Assert=>assert_Equals(
          act   = check
          exp   = abap_true
        ).

  endmethod.

  method gender_validation.

    f_cut = new zcl_Customer_Data_Validator(  ).

    data(check) = f_cut->gender_validation( gender = 'M' ).

    cl_Abap_Unit_Assert=>assert_Equals(
          act   = check
          exp   = abap_true
        ).

  endmethod.

  method home_nr_validation.

    f_cut = new zcl_Customer_Data_Validator(  ).

    data(check) = f_cut->home_nr_validation( home_nr = '95Ac' ).

    cl_Abap_Unit_Assert=>assert_Equals(
          act   = check
          exp   = abap_true
        ).

  endmethod.

  method phone_validation.

    f_cut = new zcl_Customer_Data_Validator(  ).

    data(check) = f_cut->phone_validation( phone = '0687459325' ).

    cl_Abap_Unit_Assert=>assert_Equals(
          act   = check
          exp   = abap_true
        ).

  endmethod.

  method postal_code_validation.

    f_cut = new zcl_Customer_Data_Validator(  ).

    data(check) = f_cut->postal_code_validation( postal_code = 'SW.5C /58A' ).

    cl_Abap_Unit_Assert=>assert_Equals(
          act   = check
          exp   = abap_true
        ).

  endmethod.

  method street_validation.

    f_cut = new zcl_Customer_Data_Validator(  ).

    data(check) = f_cut->street_validation( street = 'Nineth. - Street' ).

    cl_Abap_Unit_Assert=>assert_Equals(
          act   = check
          exp   = abap_true
        ).

  endmethod.

endclass.
