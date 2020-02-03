#/bin/sh

######################### READ AND VALIDATE USER INPUT #########################
prog="debianize.sh"

help_msg="\
Description:
  The program prepares Debian packages of the project.
  It must be called from project's root directory.
  The program creates \`_build_deb\` subdirectory for its operation.
  Existing \`_build_deb\` is removed. The generated packages are put in that
  directory.

Usage:
  $prog [--package_revision <rev>] <debuld_args>

Arguments:
    <debuld_args>       Arguments which are passed unchanged to debuild command.

Options:
  --package_revision    Revision of the generated package(s).
                        Must be a positive integer number. Default is 1.
  -h, --help            Print this help message.

Examples:
  Build the source package and all binary packages without signing:
  $ prog -uc -us

  Build and sign a source package of revision 3:
  $ prog --package_revision 3 -S -sa -k<key_id>

  Build and sign the source package and all binary packages or revision 4:
  $ prog --package_revision 4 -k<key_id>

  In the above examples, <key_id> is a PGP key identifier."

print_error() {
    echo "Error: $1\n$help_msg" >&2
}

if [ ! -d ".git" ]; then
    print_error "$prog must be called from the project's root directory."
    exit 1
fi

package_revision=1
debuild_args=""
while [ "$#" -ne 0 ]; do
    case "$1" in
        -h|--help)
            echo "$help_msg"
            exit 0;
            ;;
        --package_revision)
            package_revision=$2
            shift 2
            ;;
        *)  # preserve positional arguments
            debuild_args="$debuild_args $1"
            shift
            ;;
    esac
done

if [[ ! $package_revision =~ ^[1-9][0-9]*$ ]]; then
    error_msg="invalid package revision: \`$package_revision\`."
    error_msg="$error_msg Must be a positive integer number."
    print_error "$error_msg"
    exit 1
fi

##################### SET UP SOME CONSTANTS AND EXIT TRAP ######################
project_source_dir=$(pwd)
function cd_to_project_source_dir {
    cd $project_source_dir
}
trap cd_to_project_source_dir EXIT

set -ex

project_name=$(basename $project_source_dir)
project_version=$(./get_version.sh --project)
soversion=$(./get_version.sh --shared_object)
library_suffix=$(./get_version.sh --library_suffix)
package_full_name=$project_name-$project_version-$package_revision
build_dir=$project_source_dir/_build_deb

############################### PREPARE SOURCES ################################

# this execution of meson is only required to download subprojects
rm -fr $build_dir
meson $build_dir
rm -fr subprojects/packagecache
rm -fr $build_dir

rm -fr $build_dir
mkdir -p $build_dir/$package_full_name/
cp -r subprojects bin include lib unit_tests \
    LICENSE README.md man meson.build get_version.sh \
    $build_dir/$package_full_name
cd $build_dir
tar -cvzf $package_full_name.tar.gz $package_full_name/
ln -sf $package_full_name.tar.gz ${project_name}_${project_version}.orig.tar.gz

########################### PREPARE DEBIAN DIRECTORY ###########################
cd $project_source_dir
cp -r debian/ $build_dir/$package_full_name
cd $build_dir/$package_full_name
cp LICENSE debian/copyright
cd $build_dir/$package_full_name/debian
for file in *.in; do
    sed -e s/__PROJECT_VERSION__/$project_version/g \
        -e s/__SOVERSION__/$soversion/g \
        -e s/__LIBRARY_SUFFIX__/$library_suffix/g \
        -e s/__PACKAGE_REVISION__/$package_revision/g \
        <$file >${file%.in}
    rm $file
done
chmod +x rules
for file in $(ls lib*.install | grep -v '\-dev'); do
    mv $file ${file%.install}$soversion.install
done

############################## GENERATE PACKAGES ###############################
cd $build_dir/$package_full_name
debuild $debuild_args
