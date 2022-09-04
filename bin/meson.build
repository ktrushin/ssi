configure_file(
  input: 'version.hpp.in',
  output: 'version.hpp',
  configuration: {
    'version': meson.project_version()
  }
)

boost_program_options_dep = dependency('boost', modules: ['program_options'])

executable(
  'ssi',
  sources: files(['ssi.cpp']),
  cpp_args: cpp_args,
  pie: true,
  link_args: link_args,
  dependencies: [jemalloc_dep, ssi_lib_dep, boost_program_options_dep],
  install: true)
