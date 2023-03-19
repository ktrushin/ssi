#/bin/sh

set -e

clang_exe=$CLANG
clang_tidy_exe=$CLANG_TIDY
if [ -z "$clang_exe" ]; then
  clang_exe='clang++'
fi
if [ -z "$clang_tidy_exe" ]; then
  clang_tidy_exe='clang-tidy'
fi

source_files=$(find bin/ include/ lib/ -name '*.[h|c]pp')
build_dir=_build_clang_tidy
rm -fr $build_dir
CXX="$clang_exe" meson setup $build_dir
echo "starting clang-tidy"
$clang_tidy_exe -p $build_dir --quiet $source_files 2>/dev/null
echo "clang-tidy has finished"
