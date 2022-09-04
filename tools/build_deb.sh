#/bin/sh

set -eu

######################### READ AND VALIDATE USER INPUT #########################
prog=$(basename $0)

help_msg="\
Description:
  The program prepares Debian packages of the project.
  It must be called from project's root directory.
  The program creates \`_build_deb\` subdirectory for its operation.
  Existing \`_build_deb\` is removed. The generated packages are put in that
  directory.

Usage:
  $prog [-d <build_dir>] [-r <package_revision>] [<debuld_args>]

Options:
  -d <build_dir>
    Build directory. Removed if exists and created again.
    Default is '_build_deb'.

  -r <package_revision>
    Revision of the generated package(s). Must be a positive integer number.
    Default is 1.

  -o <debuld_args>
    Arguments which are passed unchanged to the 'debuild' command.
    By default, no args are passed to 'debuild'. Note: it is recommended to
    enclose the debuild arguments into signle or double quotes in order to
    prevent them being treated as the script options.

  -h
    Print this help message and exit.

Examples:
  Build the source package and all binary packages without signing:
    $prog -o '-uc -us'

  Build and sign a source package of revision 3:
    $prog -r 3 -o \"-S -sa -k<key_id>\"

  Build and sign the source package and all binary packages of revision 4:
    $prog -d _build_rev4 -r 4 -o '-k<key_id>'

  In the above examples, <key_id> is a PGP key identifier the packages are
  signed with."

abort () {
  echo "Error: $1" >&2
  exit 1
}

if [ ! -d ".git" ]; then
  abort "$prog must be called from the project's root directory."
  exit 1
fi

package_revision=1
build_dir="_build_deb"
debuild_args="-uc -us"
while getopts "hd:r:o:" opt; do
  case "$opt" in
    h) echo "$help_msg"; exit 0;;
    d) build_dir=$OPTARG;;
    r) package_revision=$OPTARG;;
    o) debuild_args="$OPTARG";;
  esac
done
shift "$((OPTIND-1))"

if ! echo "$package_revision" | grep -q '^[1-9][0-9]*$' ; then
  abort "invalid package revision: \`$package_revision\`"
fi

##################### SET UP SOME CONSTANTS AND EXIT TRAP ######################
project_root_dir=$(pwd)
cd_to_project_root_dir() {
  cd $project_root_dir
}
trap cd_to_project_root_dir EXIT


distrib_codename=$(lsb_release -cs)
project_name=$(basename $project_root_dir)
build_dir=$project_root_dir/_build_deb

############################### PREPARE SOURCES ################################

# this execution of meson is only required to download subprojects and
# define some variable
rm -fr $build_dir
meson -Ddefault_library=both $build_dir
project_version=$(meson introspect --projectinfo $build_dir | \
                  jq '.version' | tr -d '"')
execs=$(meson introspect --targets -i _build_deb/ | \
        jq -f $project_root_dir/jq/execs.jq | tr -d '"')
lib_versions=$(meson introspect --targets -i _build_deb/ | \
               jq -f $project_root_dir/jq/lib_versions.jq | tr -d '"')

echo "project_version=$project_version; execs=$execs; lib_versions=$lib_versions"

project_name_version=$project_name-$project_version

rm -fr $build_dir
mkdir -p $build_dir/$project_name_version/
cp -r subprojects bin doc include lib unit_tests \
  LICENSE README.md man meson.build VERSIONING.md \
  $build_dir/$project_name_version
cd $build_dir
tar -cJf ${project_name}_${project_version}.orig.tar.xz $project_name_version/

########################### PREPARE DEBIAN DIRECTORY ###########################
cd $project_root_dir
cp -r debian/ $build_dir/$project_name_version
cp LICENSE $build_dir/$project_name_version/debian/copyright

cd $build_dir/$project_name_version/debian

for e in $execs; do
  printf "/usr/bin/$e\n/usr/share/man/man1/$e.1\n" > $e.install
done
for l in $lib_versions; do
  name=$(echo $l | sed 's/\(.*\)\:.*/\1/g')
  uname=$(echo $name | tr [a-z] [A-Z])
  suffix=$(echo $l | sed 's/.*:\(.*\)/\1/g')
  soversion=$(echo $suffix | sed 's/\(.*\)\..*\..*/\1/g')

  echo "/usr/lib/x86_64-linux-gnu/lib$name.so.*" > lib$name$soversion.install

  echo "/usr/include/$name" > lib$name-dev.install
  echo "/usr/lib/x86_64-linux-gnu/lib$name.a" >> lib$name-dev.install
  echo "/usr/lib/x86_64-linux-gnu/lib$name.so" >> lib$name-dev.install
  echo "/usr/lib/x86_64-linux-gnu/pkgconfig/$name.pc" >> lib$name-dev.install

  echo "/usr/share/doc/lib$name-doc/html/" > lib$name-doc.install

  sed -i s/__${uname}_SOVERSION__/$soversion/g control.in
done

sed -e s/__DISTRIB_CODENAME__/$distrib_codename/g \
    -e s/__PROJECT_VERSION__/$project_version/g \
    -e s/__PACKAGE_REVISION__/$package_revision/g \
    -i changelog.in

mv control.in control
mv changelog.in changelog

############################## GENERATE PACKAGES ###############################
cd $build_dir/$project_name_version
debuild $debuild_args
