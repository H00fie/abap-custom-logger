CLASS: zcl_logging_interface DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor
                       IMPORTING path TYPE string,
             log
                       IMPORTING log_message  TYPE string
                                 message_type TYPE REF TO zcl_enum_message_type
                                 method_name  TYPE string,
             get_path
                       RETURNING value(path)  TYPE string,
             set_path
                       IMPORTING path         TYPE string.

  PRIVATE SECTION.
    DATA: path TYPE string.

    METHODS: create_log
                      IMPORTING log_message                     TYPE string
                                method_name                     TYPE string
                                message_type                    TYPE REF TO zcl_enum_message_type
                      RETURNING value(log_result)               TYPE string,
             prepare_user
                      RETURNING value(formatted_user)           TYPE string,
             prepare_message_type
                      IMPORTING message_type                    TYPE REF TO zcl_enum_message_type
                      RETURNING value(prepared_message_type)    TYPE string,
             prepare_program_method
                      IMPORTING method_name                     TYPE string
                      RETURNING value(formatted_program_method) TYPE string,
             prepare_date
                      RETURNING value(formatted_date)           TYPE string,
             prepare_hour
                      RETURNING value(formatted_hour)           TYPE string,
             save_file
                      IMPORTING log_result                      TYPE string,
             make_filename
                      RETURNING value(filename)                 TYPE string.
ENDCLASS.                    "zcl_logging_interface DEFINITION

*----------------------------------------------------------------------*
*       CLASS zcl_logging_interface IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS very_logger IMPLEMENTATION.
  METHOD constructor.
    me->path = path.
  ENDMETHOD.                    "constructor

  METHOD log.
    DATA: v_log_result TYPE string,
          v_filename   TYPE string.

    v_log_result = create_log(
                            log_message  = log_message
                            message_type = message_type
                            method_name  = method_name ).

    save_file( log_result = v_log_result ).
  ENDMETHOD.                    "log

  METHOD get_path.
    path = me->path.
  ENDMETHOD.                    "get_path

  METHOD set_path.
    me->path = path.
  ENDMETHOD.                    "set_path

  METHOD create_log.
    DATA: formatted_user           TYPE string,
          formatted_date           TYPE string,
          formatted_hour           TYPE string,
          formatted_program_method TYPE string,
          formatted_message_type   TYPE string.

    formatted_user           = prepare_user( ).
    formatted_date           = prepare_date( ).
    formatted_hour           = prepare_hour( ).
    formatted_program_method = prepare_program_method( method_name ).
    formatted_message_type   = prepare_message_type( message_type ).

    CONCATENATE  formatted_date
                 formatted_hour
                 formatted_user
                 formatted_message_type
                 formatted_program_method
                 '-'
                 log_message
                 INTO log_result SEPARATED BY space.
  ENDMETHOD.                    "create_log

  METHOD prepare_user.
    CONCATENATE '[' sy-uname ']' INTO formatted_user.
  ENDMETHOD.                    "prepare_user

  METHOD prepare_message_type.
    CASE message_type.
      WHEN message_type->info.
        prepared_message_type = 'INFO'.
      WHEN message_type->warning.
        prepared_message_type = 'WARNING'.
      WHEN message_type->error.
        prepared_message_type = 'ERROR'.
    ENDCASE.
  ENDMETHOD.                    "prepare_message_type

  METHOD prepare_program_method.
    CONCATENATE '[' sy-repid '.' method_name ']' INTO formatted_program_method.
  ENDMETHOD.                    "prepare_program_method

  METHOD prepare_date.
    CONCATENATE sy-datum(4) '-' sy-datum+4(2) '-' sy-datum+6(2) INTO formatted_date.
  ENDMETHOD.                    "prepare_date

  METHOD prepare_hour.
    CONCATENATE sy-uzeit(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2) INTO formatted_hour.
  ENDMETHOD.                    "prepare_hour

  METHOD save_file.
    DATA: directory TYPE string.

    directory = make_filename( ).

    OPEN DATASET directory FOR APPENDING IN TEXT MODE ENCODING DEFAULT.
    TRANSFER log_result TO directory.
    CLOSE DATASET directory.
  ENDMETHOD.                    "save_file

  METHOD prepare_filename.
    DATA dir TYPE string.

    dir = get_path( ).
    CONCATENATE dir '/' 'log_' sy-datum '.txt' INTO filename.
  ENDMETHOD.                    "prepare_filename


ENDCLASS.                    "zcl_logging_interface IMPLEMENTATION