*----------------------------------------------------------------------*
***INCLUDE ZCLIENT_MANAGEMENT_STATUS_0O02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'STANDARD'.
 SET TITLEBAR 'CUSTOMER MANAGEMENT'.

if lo_alv_events is initial.
create OBJECT lo_alv_events.
endif.


ENDMODULE.
