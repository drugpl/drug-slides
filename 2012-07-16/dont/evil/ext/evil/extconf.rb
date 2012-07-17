require 'mkmf'
$CFLAGS << " -DRUBY19"
$CFLAGS << " -Wall "
$CFLAGS << " -Wconversion -Wsign-compare -Wno-unused-parameter -Wwrite-strings -Wpointer-arith -fno-common -pedantic -Wno-long-long" if ENV['STRICT']
$CFLAGS << (ENV['CFLAGS'] || '')
create_makefile("evil")