project(
  'ssi',
  'cpp',
  version: '0.1.0',
  license: 'MIT',
  meson_version: '>= 0.61.2',
  subproject_dir: 'subprojects',
  default_options: [
    'cpp_std=c++17',
    'warning_level=3',
    'werror=true'
  ])

compiler_id = meson.get_compiler('cpp').get_id()
if compiler_id != 'gcc' and compiler_id != 'clang'
  msg = 'compiler `' + compiler_id + '` is not supported; '
  msg += 'please use either `g++` or `clang++`'
  error(msg)
endif

cpp_args = ['-Wconversion']
if get_option('buildtype') == 'release'
  cpp_args += ['-fvisibility=hidden']
endif

link_args = []
if get_option('b_asneeded') == false
  link_args += ['-Wl,--no-as-needed']
endif

# These compiler and linker options ensure source code hardening
# required by debian packaging.
cpp_hardening_args = [
  '-fstack-protector-strong',
  '-Wformat',
  '-Wformat-security',
  '-Werror=format-security',
  '-D_FORTIFY_SOURCE=2'
]
if compiler_id == 'gcc'
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
