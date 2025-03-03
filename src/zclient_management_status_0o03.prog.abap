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

 data(lo_changelog_alv_container) = new cl_gui_custom_container( 'SUBSCREEN_2' ).
 data(lo_changelog_alv_grid) = new cl_gui_alv_grid( lo_changelog_alv_container ).

 data(lt_changelog_fieldcatalog) = value lvc_t_fcat(
    ( fieldname = 'cur_user' col_pos = 0 scrtext_m = 'user' )
    ( fieldname = 'cur_date' col_pos = 1 scrtext_m = 'date' )
    ( fieldname = 'cur_time' col_pos = 2 scrtext_m = 'time' )
    ( fieldname = 'customer_id' col_pos = 3 scrtext_m = 'user' )
    ( fieldname = 'field_name' col_pos = 4 scrtext_m = 'field' )
    ( fieldname = 'operation_type' col_pos = 5 scrtext_m = 'operation' )
    ( fieldname = 'value_before' col_pos = 6 scrtext_m = 'before' )
    ( fieldname = 'value_after' col_pos = 7 scrtext_m = 'after' )
     ).



 select *
 from zcust_changelog
 into table @data(lt_changelog_data)
 where cur_date = @sy-datum.


 lo_changelog_alv_grid->set_table_for_first_display( CHANGING
                                                        it_outtab = lt_changelog_data
                                                        it_fieldcatalog = lt_changelog_fieldcatalog ).


ENDMODULE.
