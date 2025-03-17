*----------------------------------------------------------------------*
***INCLUDE ZCLIENT_MANAGEMENT_USER_COMI02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  "### Only two options are (at this stage) needed:
  "### SRCH_B2 - to search for entries
  "### BACK - to leave changelog.
  CASE sy-ucomm.

    WHEN 'SRCH_B2'.

      IF lt_changelog_data IS NOT INITIAL.
        CLEAR lt_changelog_data.
      ENDIF.

      SELECT *
      FROM zcust_changelog
      INTO TABLE @lt_changelog_data
      WHERE customer_id = @user_id.

      lo_changelog_alv_grid->refresh_table_display(  ).

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

  ENDCASE.

ENDMODULE.
