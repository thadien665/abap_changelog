CLASS zcl_alv_events DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS: hotspot FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING e_row_id,

      prep_data IMPORTING lt_needed_data    TYPE zcl_customer=>ls_cust_data OPTIONAL
                          lt_row_data       TYPE zcl_customer=>ls_data OPTIONAL
                RETURNING VALUE(final_data) TYPE zcl_customer=>ls_data,
      returning_data IMPORTING prepared_data      TYPE zcl_customer=>ls_data OPTIONAL
                     RETURNING VALUE(final_data1) TYPE zcl_customer=>ls_data,
      changing_data IMPORTING prepared_data TYPE zcl_customer=>ls_data.


    DATA: row_data TYPE zcl_customer=>ls_data.


  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA final_data1 TYPE zcl_customer=>ls_data.
    DATA lwa_imported_data TYPE zcl_customer=>ls_cust_data.
    DATA prepared_data TYPE zcl_customer=>ls_data.

ENDCLASS.



CLASS zcl_alv_events IMPLEMENTATION.


  METHOD prep_data.
    lwa_imported_data = lt_needed_data.
  ENDMETHOD.

  METHOD hotspot.

    READ TABLE lwa_imported_data INTO row_data INDEX e_row_id-index.
    me->changing_data( prepared_data = row_data ).

    sy-ucomm = 'REFRESH'.

    CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
      EXPORTING
        functioncode = 'REFRESH'.

  ENDMETHOD.

  METHOD changing_data.
    me->prepared_data = prepared_data.
  ENDMETHOD.

  METHOD returning_data.

    final_data1 = me->prepared_data.

  ENDMETHOD.

ENDCLASS.
