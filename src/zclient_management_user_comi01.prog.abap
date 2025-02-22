*----------------------------------------------------------------------*
***INCLUDE ZCLIENT_MANAGEMENT_USER_COMI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

"data declarations for searching fields

data: INPUT_FIRST_NAME type zcname,
      INPUT_LAST_NAME type zcname,
      INPUT_EMAIL type zcemail,
      CUST_ID_OUTPUT type zcid.

"creating ALV tab for results of search



        data(lo_alv_container) = new cl_gui_custom_container( 'SUBSCREEN_1' ).
        data(lo_alv_grid) = new cl_gui_alv_grid( lo_alv_container ).
        data lt_fieldcatalog type lvc_t_fcat.

        call FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
            i_structure_name = 'zcust_details'
        CHANGING
            ct_fieldcat = lt_fieldcatalog.

        data lt_imported_cust_data type zcl_customer=>ls_cust_data.
*        clear lt_imported_cust_data.


    data(customer) = new zcl_customer(  ).

    if sy-ucomm = 'CLEAR_BTN'.

        clear: INPUT_FIRST_NAME, INPUT_LAST_NAME, INPUT_EMAIL, CUST_ID_OUTPUT.

    endif.

    if sy-ucomm = 'CREATE_BTN'.

       if INPUT_FIRST_NAME is initial or INPUT_LAST_NAME is initial or INPUT_EMAIL is initial.
            message i002(zmsgclass).
       else.
            customer->create_customer( lv_first_name = INPUT_FIRST_NAME
                                       lv_last_name = INPUT_LAST_NAME
                                       lv_email = INPUT_EMAIL ).
            MESSAGE i001(zmsgclass).
            clear: INPUT_FIRST_NAME, INPUT_LAST_NAME, INPUT_EMAIL.
       endif.
    endif.

    if sy-ucomm = 'SEARCH_BTN'.



        if INPUT_FIRST_NAME is initial and INPUT_LAST_NAME is initial and INPUT_EMAIL is initial.
            message s003(zmsgclass).
        endif.

        if lt_imported_cust_data is not initial.
            FREE: lo_alv_grid, lo_alv_container.
            lo_alv_container = new cl_gui_custom_container( 'SUBSCREEN_1' ).
            lo_alv_grid = new cl_gui_alv_grid( lo_alv_container ).
        endif.

        customer->search_cusomer(   exporting
                                    lv_first_name = INPUT_FIRST_NAME
                                    lv_last_name = INPUT_LAST_NAME
                                    lv_email = INPUT_EMAIL
                                    importing
                                    lt_customer_data = lt_imported_cust_data ).

        lo_alv_grid->set_table_for_first_display( CHANGING
                                                    it_outtab = lt_imported_cust_data
                                                    it_fieldcatalog = lt_fieldcatalog ).

        endif.

    if sy-ucomm = 'UPDATE_BTN'.

        customer->update_customer( lv_first_name = INPUT_FIRST_NAME
                                   lv_last_name = INPUT_LAST_NAME
                                   lv_email = INPUT_EMAIL
                                   lv_cust_id = CUST_ID_OUTPUT ).


    endif.

    if sy-ucomm = 'DELETE_BTN'.


        try.
        customer->delete_customer( lv_cust_id = CUST_ID_OUTPUT ).
        message i004(zmsgclass).
        catch CX_SY_OPEN_SQL_DB into data(lcx_error).
            message lcx_error->get_text( ) type 'i'.
        endtry.
    endif.


ENDMODULE.
