CLASS zcl_alv_events DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    methods: hotspot FOR EVENT HOTSPOT_CLICK of cl_gui_alv_grid
                importing e_row_id,

             transfer_data importing lt_needed_data type zcl_customer=>ls_cust_data
                           EXPORTING row_data type zcl_customer=>ls_data
                                     hotspot_flag type string.

    data: lwa_imported_data type zcl_customer=>ls_cust_data,
          row_data type zcl_customer=>ls_data,
          hotspot_flag type string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_alv_events IMPLEMENTATION.
METHOD transfer_data.
    lwa_imported_data = lt_needed_data.
  ENDMETHOD.

  METHOD hotspot.

    read table lwa_imported_data into row_data index e_row_id-index.
    hotspot_flag = 'X'.

  ENDMETHOD.



ENDCLASS.
