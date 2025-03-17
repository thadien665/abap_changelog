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

  "### Current version of program was developed on an on-premise ABAP ASE system.
  "### Only one user, Developer, will be visible in changelog entries
  "### Because of above, searching for changes made by other users is useless.
  "### Changelog could be initially filtered only by customer_id.
  "### Further sorting/filtering options are available from ALV's toolbar.
  "### In case of production version of this program, another field like sy-uname
  "### Could be implemented.
  DATA user_id TYPE zcid.

  DATA lo_changelog_alv_grid TYPE REF TO cl_gui_alv_grid.
  DATA lo_changelog_alv_container TYPE REF TO cl_gui_custom_container.

  IF lo_changelog_alv_grid IS INITIAL.

    lo_changelog_alv_container = NEW cl_gui_custom_container( 'SUBSCREEN_2' ).
    lo_changelog_alv_grid = NEW cl_gui_alv_grid( lo_changelog_alv_container ).

    DATA(lt_changelog_fieldcatalog) = VALUE lvc_t_fcat(
       ( fieldname = 'cur_user' col_pos = 0 scrtext_m = 'user' )
       ( fieldname = 'cur_date' col_pos = 1 scrtext_m = 'date' )
       ( fieldname = 'cur_time' col_pos = 2 scrtext_m = 'time' )

       ( fieldname = 'field_name' col_pos = 4 scrtext_m = 'field' )
       ( fieldname = 'operation_type' col_pos = 3 scrtext_m = 'operation' )
       ( fieldname = 'value_before' col_pos = 5 scrtext_m = 'before' )
       ( fieldname = 'value_after' col_pos = 6 scrtext_m = 'after' )
        ).

    DATA lt_changelog_data TYPE TABLE OF zcust_changelog.

    lo_changelog_alv_grid->set_table_for_first_display( CHANGING
                                                           it_outtab = lt_changelog_data
                                                           it_fieldcatalog = lt_changelog_fieldcatalog ).

  ENDIF.


ENDMODULE.
