libssi_doxyfile = configure_file(
  input: 'doxyfile.in',
  output: 'doxyfile',
  configuration: configuration_data({
    'project_version': meson.project_version(),
    'project_source_root': meson.source_root(),
    'current_build_dir': meson.current_build_dir()
  }))

libssi_doc = custom_target(
  'libssi_doc',
  input: libssi_doxyfile,
  output: 'html',
  command: [doxygen, '@INPUT@'],
  build_by_default: true,
  build_always_stale: true,
  install: true,
  install_dir: get_option('datadir') / 'doc' / 'libssi-doc')
