*----------------------------------------------------------------------*
***INCLUDE ZCLIENT_MANAGEMENT_USER_COMI02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

    case sy-ucomm.

        when 'SRCH_B2'.

            if lt_changelog_data is not initial.
                clear lt_changelog_data.
            endif.

            select *
            from zcust_changelog
            into table @lt_changelog_data
            where customer_id = @USER_ID.

            lo_changelog_alv_grid->refresh_table_display(  ).

        when 'BACK'.
            leave to screen 0.

    endcase.

ENDMODULE.
