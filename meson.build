project(
  'ssi',
  'cpp',
  version: '0.1.0',
  license: 'MIT',
  meson_version: '>= 0.53.2',
  default_options: [
    'cpp_std=c++17',
    'warning_level=3',
    'werror=true'
  ])

cpp_args = ['-Wconversion']
if get_option('buildtype') == 'release'
  cpp_args += ['-fvisibility=hidden']
endif

link_args = []
if get_option('b_asneeded') == false
  link_args += ['-Wl,--no-as-needed']
endif

# These compiler and link flags ensure source code hardening
# required by debian packaging.
cpp_hardening_args = [
  '-fstack-protector-strong',
  '-Wformat',
  '-Wformat-security',
  '-Werror=format-security',
  '-D_FORTIFY_SOURCE=2'
]
compiler = meson.get_compiler('cpp')
if compiler.get_id() == 'gcc'
  cpp_hardening_args += ['-fstack-clash-protection']
endif
link_hardeining_args = [
  '-Wl,-z,relro',
  '-Wl,-z,defs',
  '-Wl,-z,now'
]
cpp_args += cpp_hardening_args
link_args += link_hardeining_args

jemalloc_dep = meson.get_compiler('cpp').find_library('jemalloc')

subdir('include')
subdir('lib')
subdir('bin')
subdir('unit_tests')
subdir('man')
subdir('doc')
