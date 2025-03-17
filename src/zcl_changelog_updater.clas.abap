CLASS zcl_changelog_updater DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    TYPES: lty_changelog_table TYPE TABLE OF zcust_changelog,
           BEGIN OF lty_flds_values,
             fld_name TYPE zcfieldname,
             v_before TYPE zcvaluemod,
             v_after  TYPE zcvaluemod,
           END OF lty_flds_values,
           lt_flds_values TYPE TABLE OF lty_flds_values.



    METHODS:
      getting_data
        IMPORTING
          user            TYPE zcsyuname
          date            TYPE zcdate
          time            TYPE zctime
          customer        TYPE zcid
          oper_type       TYPE zcopername
          lt_flds_values  TYPE lt_flds_values
        EXPORTING
          lt_filled_table TYPE lty_changelog_table.


  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: lt_changelog_data TYPE TABLE OF zcust_changelog,
          lwa_changelog_row TYPE zcust_changelog.

    METHODS:
      inserting_row
        IMPORTING
          lt_ready_table TYPE lty_changelog_table.

ENDCLASS.



CLASS zcl_changelog_updater IMPLEMENTATION.
  METHOD getting_data.


    LOOP AT lt_flds_values INTO DATA(lwa_fltds_values).
      APPEND VALUE #( cur_user = user
                      cur_date = date
                      cur_time = time
                      operation_type = oper_type
                      customer_id = customer
                      field_name = lwa_fltds_values-fld_name
                      value_before = lwa_fltds_values-v_before
                      value_after = lwa_fltds_values-v_after )
       TO lt_filled_table.
    ENDLOOP.

    me->inserting_row( lt_filled_table ).

  ENDMETHOD.

  METHOD inserting_row.

    INSERT zcust_changelog FROM TABLE lt_ready_table.

  ENDMETHOD.

ENDCLASS.
