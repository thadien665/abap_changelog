*----------------------------------------------------------------------*
***INCLUDE ZCLIENT_MANAGEMENT_STATUS_0O03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
* SET PF-STATUS 'CHANGELOG DISPLAY'.
 SET TITLEBAR 'CHANGELOG DISPLAY'.

 data USER_ID type zcid.

 data lo_changelog_alv_grid type ref to cl_gui_alv_grid.
 data lo_changelog_alv_container type ref to cl_gui_custom_container.

 if lo_changelog_alv_grid is initial.

 lo_changelog_alv_container = new cl_gui_custom_container( 'SUBSCREEN_2' ).
 lo_changelog_alv_grid = new cl_gui_alv_grid( lo_changelog_alv_container ).

 data(lt_changelog_fieldcatalog) = value lvc_t_fcat(
    ( fieldname = 'cur_user' col_pos = 0 scrtext_m = 'user' )
    ( fieldname = 'cur_date' col_pos = 1 scrtext_m = 'date' )
    ( fieldname = 'cur_time' col_pos = 2 scrtext_m = 'time' )

    ( fieldname = 'field_name' col_pos = 4 scrtext_m = 'field' )
    ( fieldname = 'operation_type' col_pos = 3 scrtext_m = 'operation' )
    ( fieldname = 'value_before' col_pos = 5 scrtext_m = 'before' )
    ( fieldname = 'value_after' col_pos = 6 scrtext_m = 'after' )
     ).

    data lt_changelog_data type table of zcust_changelog.

 lo_changelog_alv_grid->set_table_for_first_display( CHANGING
                                                        it_outtab = lt_changelog_data
                                                        it_fieldcatalog = lt_changelog_fieldcatalog ).

 endif.


ENDMODULE.
