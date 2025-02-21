CLASS zcl_customer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

        TYPES: BEGIN OF lwa_cust_data,
                       cust_id type zcid,
                       cust_fname type zcname,
                       cust_lname type zcname,
                       cust_email type zcemail,
                       end of lwa_cust_data.
     methods:
        create_customer
            importing
                lv_first_name type zcname
                lv_last_name  type zcname
                lv_email      type zcemail,
        search_cusomer
            importing
                lv_first_name type zcname
                lv_last_name  type zcname
                lv_email      type zcemail
            exporting
                lwa_customer_data type lwa_cust_data,
        update_customer
            importing
                lv_first_name type zcname
                lv_last_name  type zcname
                lv_email      type zcemail
                lv_cust_id type zcid,
        delete_customer
            importing
                lv_cust_id type zcid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_customer IMPLEMENTATION.
  METHOD create_customer.

    data lv_new_customer type zcust_details.

*    select max( cust_id )
*    from zcust_details
*    into @data(lv_max_existing_id).

     select cast( cust_id as int2 )
     from zcust_details
     into table @data(lt_cust_id).

     loop at lt_cust_id into data(current_id).
        if lt_cust_id[ sy-tabix + 1 ] <> current_id + 1.
            data(lv_max_existing_id) = lt_cust_id[ sy-tabix ].
            exit.
        endif.
     endloop.

    lv_new_customer-cust_id = lv_max_existing_id + 1.
    lv_new_customer-cust_fname = lv_first_name.
    lv_new_customer-cust_lname = lv_last_name.
    lv_new_customer-cust_email = lv_email.

    INSERT zcust_details from lv_new_customer.

  ENDMETHOD.


  METHOD search_cusomer.

    data lv_where_builder type string.
    data lt_builder_parts type table of string.

    if lv_first_name is not initial.
        append |cust_fname = @lv_first_name| to lt_builder_parts.
    endif.
    if lv_last_name is not initial.
        append |cust_lname = @lv_last_name| to lt_builder_parts.
    endif.
    if lv_email is not initial.
        append |cust_email = @lv_email| to lt_builder_parts.
    endif.

    if lines( lt_builder_parts ) = 1.
        lv_where_builder = lt_builder_parts[ 1 ].
    else.
        CONCATENATE LINES OF lt_builder_parts into lv_where_builder SEPARATED BY ' AND '.
    endif.

    select single cust_id, cust_fname, cust_lname, cust_email
    from zcust_details
    into @lwa_customer_data
    where (lv_where_builder).

  ENDMETHOD.

  METHOD update_customer.

    update zcust_details
    set cust_fname = @lv_first_name, cust_lname = @lv_last_name, cust_email = @lv_email
    where cust_id = @lv_cust_id.
    Commit work.

  ENDMETHOD.

  METHOD delete_customer.

    data lwa_customer_details type zcust_details.


    if lv_cust_id is not initial.

        lwa_customer_details-cust_id = lv_cust_id.

        update zcust_details from lwa_customer_details.
        Commit work.

    endif.

  ENDMETHOD.

ENDCLASS.
