*----------------------------------------------------------------------*
***INCLUDE ZCLIENT_MANAGEMENT_STATUS_0O02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  "### Hiding address fields and labels at program launch.
  IF sy-ucomm <> 'ADRES_BTN'.
    LOOP AT SCREEN.
      IF screen-group1 = '111'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  "### Related to 'ADRES_BTN' option from 100 PAI - to show/hide address fields.
  IF lv_flag_invis = 'do_change'.
    LOOP AT SCREEN.
      IF screen-group1 = '111'.
        IF lv_flag_change = 'to visible'.
          screen-active = 1.
          screen-invisible = 0.
        ELSEIF lv_flag_change = 'to invisible'.
          screen-active = 0.
          screen-invisible = 1.
        ENDIF.
        MODIFY SCREEN.
        lv_flag_invis = ''.
      ENDIF.
    ENDLOOP.
  ENDIF.

  SET PF-STATUS 'STANDARD'.
  SET TITLEBAR 'CUSTOMER MANAGEMENT'.



  IF lo_alv_events IS INITIAL.
    CREATE OBJECT lo_alv_events.
  ENDIF.



ENDMODULE.
