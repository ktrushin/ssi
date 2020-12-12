lib_private_include_dir = include_directories('.')

ssi_lib_sources = files([
  'ssi/local_time.cpp',
  'ssi/thread_count.cpp'
])

boost_date_time_dep =  dependency('boost', modules: ['date_time'])
boost_thread_dep = dependency('boost', modules: ['thread', 'system'])

ssi_lib = library(
  'ssi',
  version: run_command(get_version, '--library_suffix').stdout().strip(),
  sources: ssi_lib_sources,
  include_directories: [public_include_dir, lib_private_include_dir],
  cpp_args: cpp_args,
  link_args: link_args,
  dependencies: [jemalloc_dep, boost_date_time_dep, boost_thread_dep],
  install: true)

pkg_mod = import('pkgconfig')
pkg_mod.generate(ssi_lib, description: 'Some System Information library')

ssi_lib_dep = declare_dependency(
  include_directories: public_include_dir,
  link_with: ssi_lib,
  dependencies: [boost_date_time_dep])
