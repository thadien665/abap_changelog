*"* use this source file for your ABAP unit test classes


class name_Validation_1 definition for testing
  duration short
  risk level harmless
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>name_Validation_1
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>ZCL_CUSTOMER_DATA_VALIDATOR
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE/>
*?<GENERATE_CLASS_FIXTURE/>
*?<GENERATE_INVOCATION/>
*?<GENERATE_ASSERT_EQUAL/>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  private section.
    data:
      f_Cut type ref to zcl_Customer_Data_Validator.  "class under test

    methods: names_Validation for testing.
endclass.       "name_Validation_1


class name_Validation_1 implementation.

  method names_Validation.

    f_cut = new zcl_Customer_Data_Validator(  ).

    data(check) = f_cut->names_validation( name = 'anna maria' ).


    cl_Abap_Unit_Assert=>assert_Equals(
          act   = check
          exp   = abap_true          "<--- please adapt expected value
        " msg   = 'Testing value check'
*         level =
        ).


  endmethod.




endclass.

*class name_Validation_2 definition for testing
*  duration short
*  risk level harmless
*.
**?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
**?<asx:values>
**?<TESTCLASS_OPTIONS>
**?<TEST_CLASS>name_Validation_2
**?</TEST_CLASS>
**?<TEST_MEMBER>f_Cut
**?</TEST_MEMBER>
**?<OBJECT_UNDER_TEST>ZCL_CUSTOMER_DATA_VALIDATOR
**?</OBJECT_UNDER_TEST>
**?<OBJECT_IS_LOCAL/>
**?<GENERATE_FIXTURE/>
**?<GENERATE_CLASS_FIXTURE/>
**?<GENERATE_INVOCATION/>
**?<GENERATE_ASSERT_EQUAL>X
**?</GENERATE_ASSERT_EQUAL>
**?</TESTCLASS_OPTIONS>
**?</asx:values>
**?</asx:abap>
*  private section.
*    data:
*      f_Cut type ref to zcl_Customer_Data_Validator.  "class under test
*
*    methods: names_Validation for testing.
*endclass.       "name_Validation_2
*
*
*class name_Validation_2 implementation.

*  method names_Validation.
*
*
*
*
*    cl_Abap_Unit_Assert=>assert_Equals(
*      act   = check
*      exp   = check          "<--- please adapt expected value
*    " msg   = 'Testing value check'
**     level =
*    ).
*  endmethod.
*
*
*
*
*endclass.
