CLASS zcl_alv_events DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    methods: hotspot FOR EVENT HOTSPOT_CLICK of cl_gui_alv_grid
                            importing E_ROW_ID,

             prep_data importing lt_needed_data type zcl_customer=>ls_cust_data OPTIONAL
                           lt_row_data type zcl_customer=>ls_data OPTIONAL
                           RETURNING VALUE(final_data) type zcl_customer=>ls_data.

    data: lwa_imported_data type zcl_customer=>ls_cust_data,
          row_data type zcl_customer=>ls_data.


  PROTECTED SECTION.
  PRIVATE SECTION.

  data final_data1 type zcl_customer=>ls_data.

ENDCLASS.



CLASS zcl_alv_events IMPLEMENTATION.
METHOD prep_data.
    if final_data1 is initial.
    lwa_imported_data = lt_needed_data.
    final_data1 = lt_row_data.
    endif.
    final_data = final_data1.

  ENDMETHOD.

  METHOD hotspot.

    read table lwa_imported_data into row_data index 1.
    me->prep_data( lt_row_data = row_data ).

    sy-ucomm = 'REFRESH'.

    CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
    EXPORTING
      functioncode = 'REFRESH'.

  ENDMETHOD.




ENDCLASS.
