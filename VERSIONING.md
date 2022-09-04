# Versioning

The project itself is versioned according to
[semantic versioning scheme](https://semver.org/). However, the shared library
should be versioned independently of the project in order to establish backward
compatibility on both semantical and _binary_ levels. The
[Libtool versioning system](https://www.gnu.org/software/libtool/manual/libtool.html#Libtool-versioning)
is used for that. The shared library version comprises three components
separated by colons as follows: `current:revision:age`.
The library file gets suffix `(current - age).revision.age`
where value `(curent - age)` is a shared object version aka soversion.
Please see [here](https://dcreager.net/shared-library-versions/) and
[here](https://github.com/pvanhoof/dir-examples) for more details.

Project version is specified as an argument of the `project` command in the
root `meson.build` file. Library versions are specified in the respective
`meson.build` files alongside with the library compilation target definitions.
