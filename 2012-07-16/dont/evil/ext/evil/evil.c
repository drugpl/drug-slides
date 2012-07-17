#include <ruby.h>
#include <ruby/st.h>

#define RBASIC_KLASS(o) (RBASIC(o)->klass)
#define RCLASS_SET_SUPER(o, c) (RCLASS(o)->ptr->super = c)

static VALUE evil_uninclude(VALUE klass, VALUE mod) {
  VALUE cur, prev;

  for (prev = klass, cur = RCLASS_SUPER(klass); cur ; prev = cur, cur = RCLASS_SUPER(cur)) {
    if (BUILTIN_TYPE(prev) == T_CLASS) {
      rb_clear_cache_by_class(prev);
    }
    if (BUILTIN_TYPE(cur) == T_ICLASS && RBASIC_KLASS(cur) == mod) {
      RCLASS_SET_SUPER(prev, RCLASS_SUPER(cur));
      return mod;
    }
  }

  return Qnil;
}

void Init_evil(void) {
  rb_define_method(rb_cModule, "uninclude", evil_uninclude, 1);
}