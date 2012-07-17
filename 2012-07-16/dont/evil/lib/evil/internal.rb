require 'dl'
require 'dl/value'
require 'dl/import'
require 'dl/struct'

module RubyInternal
  extend DL::Importer
  dlload

  Qfalse = 0
  Qtrue  = 2
  Qnil   = 4
  Qundef = 6

  T_NONE   = 0x00

  T_OBJECT = 0x01
  T_CLASS  = 0x02
  T_MODULE = 0x03
  T_FLOAT  = 0x04
  T_STRING = 0x05
  T_REGEXP = 0x06
  T_ARRAY  = 0x07
  T_HASH   = 0x08
  T_STRUCT = 0x09
  T_BIGNUM = 0x0a
  T_FILE   = 0x0b
  T_DATA   = 0x0c
  T_MATCH  = 0x0d
  T_COMPLEX  = 0x0e
  T_RATIONAL = 0x0f

  T_NIL    = 0x11
  T_TRUE   = 0x12
  T_FALSE  = 0x13
  T_SYMBOL = 0x14
  T_FIXNUM = 0x15

  T_UNDEF  = 0x1b
  T_NODE   = 0x1c
  T_ICLASS = 0x1d
  T_ZOMBIE = 0x1e

  T_MASK   = 0x1f

  typealias "VALUE", "unsigned long"
  typealias "ID", "unsigned long"
  typealias "ulong", "unsigned long"

  Basic = [
    "VALUE flags",
    "VALUE klass"
  ]

  RBasic = struct(Basic)

  object_struct = [
    'long numiv',
    'VALUE *ivptr',
    'st_table *iv_index_tbl',
    'VALUE ara[3]'
  ]

  RObject = struct(Basic + object_struct)

  ClassStruct = [
    'rb_classext_t *ptr',
    'st_table *m_tbl',
    'st_table *iv_index_tbl'
  ]

  RClass = struct(Basic + ClassStruct)
  RClass::Extension = struct([
    "VALUE super",
    "st_table *iv_tbl"
  ])

  class RClass
    def ext; Extension.new(self.ext).super end
    def iv_tbl; Extension.new(self.ext).iv_tbl end
    def iv_tbl=(value); Extension.new(self.ext).iv_tbl = value end
    def super; Extension.new(self.ext).super end
    def super=(value); Extension.new(self.ext).super= value end
  end

  RModule = RClass

  #struct RArray {
  #  struct RBasic basic;
  #  union {
  #    struct {
  #      long len;
  #      union {
  #        long capa;
  #        VALUE shared;
  #      } aux;
  #      VALUE *ptr;
  #    } heap;
  #    VALUE ary[RARRAY_EMBED_LEN_MAX];
  #  } as;
  #};

  RArray = struct(Basic +
    [
      'long len',
      'long capa',
      'VALUE shared',
      'VALUE *ptr',
      'VALUE ary[3]'
    ]
  )

  RData = struct(Basic + [
      "void *dmark",
      "void *dfree",
      "void *data"
  ])

  FL_USHIFT     = 12
  FL_USER0      = 1 << (FL_USHIFT + 0)
  FL_USER1      = 1 << (FL_USHIFT + 1)
  FL_USER2      = 1 << (FL_USHIFT + 2)
  FL_USER3      = 1 << (FL_USHIFT + 3)
  FL_USER4      = 1 << (FL_USHIFT + 4)
  FL_USER5      = 1 << (FL_USHIFT + 5)
  FL_USER6      = 1 << (FL_USHIFT + 6)
  FL_USER7      = 1 << (FL_USHIFT + 7)
  FL_USER8      = 1 << (FL_USHIFT + 8)
  FL_USER9      = 1 << (FL_USHIFT + 9)
  FL_USER10     = 1 << (FL_USHIFT + 10)
  FL_USER11     = 1 << (FL_USHIFT + 11)
  FL_USER12     = 1 << (FL_USHIFT + 12)
  FL_USER13     = 1 << (FL_USHIFT + 13)
  FL_USER14     = 1 << (FL_USHIFT + 14)
  FL_USER15     = 1 << (FL_USHIFT + 15)
  FL_USER16     = 1 << (FL_USHIFT + 16)
  FL_USER17     = 1 << (FL_USHIFT + 17)
  FL_USER18     = 1 << (FL_USHIFT + 18)
  FL_USER19     = 1 << (FL_USHIFT + 19)

  FL_SINGLETON = FL_USER0
  FL_MARK      = 1 <<5
  FL_RESERVED  = 1 <<6
  FL_FINALIZE  = 1 <<7
  FL_TAINT     = 1 <<8
  FL_UNTRUSTED = 1 <<9
  FL_EXIVAR    = 1 <<10
  FL_FREEZE    = 1 <<11
end