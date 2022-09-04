ssi_lib_private_include_dir = include_directories('.')

ssi_lib_sources = files([
  'local_time.cpp',
  'thread_count.cpp'
])

boost_date_time_dep =  dependency('boost', modules: ['date_time'])
boost_thread_dep = dependency('boost', modules: ['thread', 'system'])

# Library version in Libtool format
ssi_lib_current=0
ssi_lib_revision=0
ssi_lib_age=0
ssi_lib_version=(ssi_lib_current - ssi_lib_age).to_string() + \
  '.' + ssi_lib_age.to_string() + '.' + ssi_lib_revision.to_string()

ssi_lib = library(
  'ssi',
  version: ssi_lib_version,
  sources: ssi_lib_sources,
  include_directories: [public_include_dir, ssi_lib_private_include_dir],
  cpp_args: cpp_args,
  link_args: link_args,
  dependencies: [jemalloc_dep, boost_date_time_dep, boost_thread_dep],
  install: true)

pkg_mod = import('pkgconfig')
pkg_mod.generate(ssi_lib, description: 'Some System Information library')

ssi_lib_dep = declare_dependency(
  include_directories: public_include_dir,
  link_with: ssi_lib,
  # Since the `local_time` function returns an object of the
  # `boost::posix_time::ptime` type (please see the `lib/ssi/local_time.cpp`
  # file), the `Boost.DataTime` libary is a _public_ dependency of the `ssi`
  # library and should be forwarded with the `dependencies` option.
  dependencies: [boost_date_time_dep])
