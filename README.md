# ssi
Some System Information - a toy project for demonstrating C++ development
environment and tool usage.

The main purpose of this project is to serve as a template for other
C++ projects. In order to isolate development environment from the
host machine configuration, a Docker container based on Ubuntu 18.04 is used.
Development toolchain is installed into the container and project's source
directory is mapped there. As a result, one can edit sources on the
host machine using his favorite editor or IDE and compile them
within the container.

The project implements a simple binary (`ssi`) which is linked against
a library (`libssi`). Neither the library nor the binary solve any practical
problem except being an example of using the external dependencies
(various [Boost](https://www.boost.org/) libraries in this case).
The binary prints the total number of processor threads on the machine and
local date and time. When executed in the container, the latter may differ
from the date and time on the host machine because the container
uses UTC timezone.

In regards to storing C++ code, placing everything into single `src` directory
is intentionally avoided. Instead, three separate directories are used:
`lib` and `bin` keep sources of the libraries and binaries respectively,
`include` is dedicated for public header files of the libraries.
Not olnly does it intoroduce a better layout and but also prevents too deep
directory nesting. Each of three directories mentioned above has a separate
subdirectory for each library/binary (only `ssi` at the moment). That makes
it easy to extend the project with other libraries/binaries just by placing
their subdirectories alongside with existing one.

At the moment, only Ubuntu 18.04 is used as a base system for
the development environment. In the future, the project may be also supported
on Ubuntu 20.04 after the latter has been released.
But for now the environmet lives in a Docker container `ssi_bionic`
which features g++-8 and clang++-8 as compilers. They are the most recent
version available from the standard repositories. The build may be sped up
using `ccache`. The project also makes use of clang-format-8 and clang-tidy-8
to ensure better code style and quality. As a build system,
[Meson](https://mesonbuild.com/) of version 0.52.0 (installed from
[this](https://launchpad.net/~jonathonf/+archive/ubuntu/meson) PPA) is used.
Meson provides much cleaner and more logical DSL than CMake does.
The only thing Meson misses is some analog of
[CPack](https://cmake.org/cmake/help/v3.16/module/CPack.html).
However, the project overcomes that with a `tools/debianize.sh` script.
The project uses `get_version.sh` script as a single point for defining
the versions during both build and debianization stages.

### Some instructions

Create Docker image and container if that hasn't been done yet,
execute bash in the container (requires Docker 18.09 or higher):
```
host_promtp> git clone git@github.com:ktrushin/ssi.git
host_prompt> cd ssi
host_prompt> ./tools/docker.sh
```
The rest of the instructions are executed in the container.

Run the formatter and the linter:  
```
container_prompt> CLANG_FORMAT='clang-format-8' ./tools/clang-format.sh
container_prompt> CLANT_TIDY='clang-tidy-8' ./tools/clang-tidy.sh
```

Compile the project and execute the resulting binary:
```
container_prompt> CXX='ccache g++-8' meson -Db_asneeded=false _build
container_prompt> ninja -v -C _build -j$(nproc)
container_prompt> ./_build/bin/ssi
Number of threads: 4
Local time: 2020-Feb-09 13:00:31
```

Install and uninstall:
```
container_prompt> sudo ninja -v -C _build install
container_prompt> sudo ldcofing
container_prompt> which ssi
/usr/local/bin/ssi
container_prompt> ssi
Number of threads: 4
Local time: 2020-Feb-09 13:00:31
container_prompt> sudo ninja -v -C _build uninstall
```

Build, install and uninstall Debian packages:
```
container_prompt> ./tools/debianize.sh
<lots of output here>
container_prompt> ls _build_deb
libssi0_0.1.0-1_amd64.deb          ssi_0.1.0-1_amd64.deb
libssi0-dbgsym_0.1.0-1_amd64.ddeb  ssi_0.1.0-1.debian.tar.xz
libssi-dev_0.1.0-1_amd64.deb       ssi_0.1.0-1.dsc
ssi-0.1.0-1                        ssi-0.1.0-1.tar.gz
ssi_0.1.0-1_amd64.build            ssi_0.1.0.orig.tar.gz
ssi_0.1.0-1_amd64.buildinfo        ssi-dbgsym_0.1.0-1_amd64.ddeb
ssi_0.1.0-1_amd64.changes
container_prompt> cd _build_deb
container_prompt> sudo dpkg -i libssi0_0.1.0-1_amd64.deb ssi_0.1.0-1_amd64.deb
container_prompt> which ssi
/usr/bin/ssi
container_prompt> ssi
Number of threads: 4
Local time: 2020-Feb-09 13:00:31
container_prompt> sudo apt-get purge ssi libssi0
```
The Debian packages may be also installed form
[this](https://launchpad.net/~ktrushin/+archive/ubuntu/ssi) PPA.

Although the project is created to be used mostly by the author as
a source of examples for setting up a development environment,
writing Meson build files and preparing Debian packages,
others may also find it useful.
