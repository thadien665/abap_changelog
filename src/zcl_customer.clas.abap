CLASS zcl_customer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

        TYPES: BEGIN OF ls_data,
                       cust_id type zcid,
                       cust_fname type zcname,
                       cust_lname type zcname,
                       cust_email type zcemail,
                       end of ls_data.

        types: ls_cust_data type table of ls_data.

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
                lt_customer_data  type ls_cust_data,
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

    data: lv_new_customer type zcust_details,
          lv_int_cust_id type i.

     select min( customer_id )
     from zcust_id_storage
     into @data(lv_max_existing_id).

    if lv_max_existing_id is initial.

         select max( cust_id )
         from zcust_details
         into lv_max_existing_id.

        lv_int_cust_id = lv_max_existing_id + 1.
        lv_new_customer-cust_id = lv_int_cust_id.

    else.
        lv_new_customer-cust_id = lv_max_existing_id.
        delete from zcust_id_storage where customer_id = lv_max_existing_id.
    endif.

    lv_new_customer-cust_fname = lv_first_name.
    lv_new_customer-cust_lname = lv_last_name.
    lv_new_customer-cust_email = lv_email.

    INSERT zcust_details from lv_new_customer.
    commit work.

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

    select cust_id, cust_fname, cust_lname, cust_email
    from zcust_details
    into table @lt_customer_data
    where (lv_where_builder).

  ENDMETHOD.

  METHOD update_customer.

    update zcust_details
    set cust_fname = @lv_first_name, cust_lname = @lv_last_name, cust_email = @lv_email
    where cust_id = @lv_cust_id.
    Commit work.

  ENDMETHOD.

  METHOD delete_customer.

    data lwa_removed_id type zcust_id_storage.


    if lv_cust_id is not initial.

        lwa_removed_id-customer_id = lv_cust_id.
        insert into zcust_id_storage values lwa_removed_id.

        delete from zcust_details where cust_id = lv_cust_id.
        Commit work.

    endif.

  ENDMETHOD.

ENDCLASS.
