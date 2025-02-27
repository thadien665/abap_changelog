*&---------------------------------------------------------------------*
*& Modulpool ZCLIENT_MANAGEMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM ZCLIENT_MANAGEMENT.

 Data: INPUT_FIRST_NAME_2 type zcname,
        INPUT_LAST_NAME_2 type zcname,
        INPUT_EMAIL_2 type zcemail,
        CUST_ID_OUTPUT_2 type zcid.

data lo_alv_events type ref to zcl_alv_events.
INITIALIZATION.
create OBJECT lo_alv_events.


INCLUDE zclient_management_user_comi01.

INCLUDE zclient_management_status_0o02.
