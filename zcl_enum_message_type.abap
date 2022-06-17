CLASS zcl_enum_message_type DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: info    TYPE REF TO zcl_enum_message_type READ-ONLY,
                error   TYPE REF TO zcl_enum_message_type READ-ONLY,
                warning TYPE REF TO zcl_enum_message_type READ-ONLY.

    CLASS-METHODS: class_constructor.
ENDCLASS.                    "zcl_enum_message_type DEFINITION

*----------------------------------------------------------------------*
*       CLASS zcl_enum_message_type IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS zcl_enum_message_type IMPLEMENTATION.
  METHOD class_constructor.
    CREATE OBJECT: info, error, warning.
  ENDMETHOD.                    "class_constructor
ENDCLASS.                    "zcl_enum_message_type IMPLEMENTATION