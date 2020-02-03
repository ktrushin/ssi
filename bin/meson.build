subdir('common')

bin_private_include_dir = include_directories('.')

boost_program_options_dep = dependency('boost', modules: ['program_options'])

executable(
  'ssi',
  sources: files(['ssi/ssi.cpp']),
  include_directories: [bin_private_include_dir],
  cpp_args: cpp_args,
  pie: true,
  link_args: link_args,
  dependencies: [jemalloc_dep, ssi_lib_dep, boost_program_options_dep],
  install: true)
