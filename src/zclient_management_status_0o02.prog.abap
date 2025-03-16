*----------------------------------------------------------------------*
***INCLUDE ZCLIENT_MANAGEMENT_STATUS_0O02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
    if lv_flag_invis = 'do_change'.
    loop at screen.
            if screen-group1 = '111'.
                if lv_flag_change = 'to visible'.
                    screen-active = 1.
                elseif lv_flag_change = 'to invisible'.
                    screen-active = 0.
                endif.
                MODIFY SCREEN.
                lv_flag_invis = ''.
            endif.
        endloop.
     endif.

 SET PF-STATUS 'STANDARD'.
 SET TITLEBAR 'CUSTOMER MANAGEMENT'.



if lo_alv_events is initial.
create OBJECT lo_alv_events.
endif.



ENDMODULE.
