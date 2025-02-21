*----------------------------------------------------------------------*
***INCLUDE ZCLIENT_MANAGEMENT_USER_COMI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

data: INPUT-FIRST_NAME type zcname,
      INPUT-LAST_NAME type zcname,
      INPUT-EMAIL type zcemail,
      CUST_ID_OUTPUT type zcid.

     data(customer) = new zcl_customer(  ).


    if sy-ucomm = 'CLEAR_BTN'.

        clear: INPUT-FIRST_NAME, INPUT-LAST_NAME, INPUT-EMAIL, CUST_ID_OUTPUT.

    endif.

    if sy-ucomm = 'CREATE_BTN'.

       if INPUT-FIRST_NAME is initial or INPUT-LAST_NAME is initial or INPUT-EMAIL is initial.
            message i002(zmsgclass).
       else.
            customer->create_customer( lv_first_name = INPUT-FIRST_NAME
                                       lv_last_name = INPUT-LAST_NAME
                                       lv_email = INPUT-EMAIL ).
            MESSAGE i001(zmsgclass).
            clear: INPUT-FIRST_NAME, INPUT-LAST_NAME, INPUT-EMAIL.
       endif.

    elseif sy-ucomm = 'SEARCH_BTN'.

        if INPUT-FIRST_NAME is initial and INPUT-LAST_NAME is initial and INPUT-EMAIL is initial.
            message s003(zmsgclass).
        else.

             data lwa_imported_cust_data type zcl_customer=>lwa_cust_data.

        customer->search_cusomer(   exporting
                                    lv_first_name = INPUT-FIRST_NAME
                                    lv_last_name = INPUT-LAST_NAME
                                    lv_email = INPUT-EMAIL
                                    importing
                                    lwa_customer_data = lwa_imported_cust_data ).

        INPUT-FIRST_NAME = lwa_imported_cust_data-cust_fname.
        INPUT-LAST_NAME = lwa_imported_cust_data-cust_lname.
        INPUT-EMAIL = lwa_imported_cust_data-cust_email.
        CUST_ID_OUTPUT = lwa_imported_cust_data-cust_id.



        endif.

    elseif sy-ucomm = 'UPDATE_BTN'.

        customer->update_customer( lv_first_name = INPUT-FIRST_NAME
                                   lv_last_name = INPUT-LAST_NAME
                                   lv_email = INPUT-EMAIL
                                   lv_cust_id = CUST_ID_OUTPUT ).


    endif.

    if sy-ucomm = 'DELETE_BTN'.

        try.
        customer->delete_customer( lv_cust_id = CUST_ID_OUTPUT ).
        message i004(zmsgclass).
        catch CX_SY_OPEN_SQL_DB into data(lcx_error).
            message lcx_error->record_not_found() type 'i'.
        endtry.
    endif.


ENDMODULE.
