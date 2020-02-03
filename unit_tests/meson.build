gtest_proj = subproject('gtest')
gtest_main_dep = gtest_proj.get_variable('gtest_main_dep')

ssi_unit_sources = files([
  'ssi/local_time_test.cpp',
  'ssi/thread_count_test.cpp'
])

ssi_unit = executable(
  'ssi',
  sources: ssi_unit_sources,
  cpp_args: cpp_args,
  link_args: link_args,
  dependencies : [jemalloc_dep, ssi_lib_dep, gtest_main_dep],
  install : false)
test('ssi_unit', ssi_unit)
