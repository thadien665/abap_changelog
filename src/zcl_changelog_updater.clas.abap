CLASS zcl_changelog_updater DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    types: lty_changelog_table type table of zcust_changelog,
           begin of lty_flds_values,
           fld_name type ZCFIELDNAME,
           v_before type ZCVALUEMOD,
           v_after type ZCVALUEMOD,
           END OF lty_flds_values,
           lt_flds_values type table of lty_flds_values.



    methods:
          getting_data
            IMPORTING
                user           type ZCSYUNAME
                date           type ZCDATE
                time           type ZCTIME
                customer       type ZCID
                oper_type      type ZCOPERNAME
                lt_flds_values type lt_flds_values
            EXPORTING
                lt_filled_table type lty_changelog_table.


  PROTECTED SECTION.
  PRIVATE SECTION.

    data: lt_changelog_data type table of zcust_changelog,
          lwa_changelog_row type zcust_changelog.

    methods:
        inserting_row
            IMPORTING
                lt_ready_table type lty_changelog_table.

ENDCLASS.



CLASS zcl_changelog_updater IMPLEMENTATION.
  METHOD getting_data.


    loop at lt_flds_values into data(lwa_fltds_values).
        append value #( cur_user = user
                        cur_date = date
                        cur_time = time
                        operation_type = oper_type
                        customer_id = customer
                        field_name = lwa_fltds_values-fld_name
                        value_before = lwa_fltds_values-v_before
                        value_after = lwa_fltds_values-v_after )
         to lt_filled_table.
    endloop.

    me->inserting_row( lt_filled_table ).

  ENDMETHOD.

  METHOD inserting_row.

    insert zcust_changelog from table lt_ready_table.

  ENDMETHOD.

ENDCLASS.
