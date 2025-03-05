*"* use this source file for your ABAP unit test classes

class name_Validation_1 definition for testing
  duration short
  risk level harmless.

  private section.
    data:
      f_Cut type ref to zcl_Customer_Data_Validator.  "class under test

    methods: names_Validation for testing,
             email_validation for testing.
endclass.       "name_Validation_1


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


  endmethod.

endclass.
