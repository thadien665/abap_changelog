*----------------------------------------------------------------------*
***INCLUDE ZCLIENT_MANAGEMENT_STATUS_0O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.

*if sy-ucomm = 'SEARCH_BTN' and lo_alv_grid is not initial.
*    clear lo_alv_grid.
*endif.
ENDMODULE.
