# ssi
Some System Information - a toy project for demonstrating C++ development
environment and toolchain usage.

The main purpose of this project is to serve as a template for other
C++ projects. In order to isolate development environment from the
host machine configuration, a Docker container based on Ubuntu 22.04 is used.
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
uses UTC time.

In regards to storing C++ code, placing everything into single `src` directory
is intentionally avoided. Instead, three separate directories are used:
`lib` and `bin` keep sources of the libraries and binaries respectively,
`include` is dedicated for public header files of the libraries.
Not olnly does this approach intoroduce a better layout and but it also prevents
too deep directory nesting. Each of three directories mentioned above
has a separate subdirectory for each library/binary (only `ssi` at the moment).
That makes it easy to extend the project with other libraries/binaries just by
placing their subdirectories alongside with existing one.

As a base system for the development environment, one may use either
Ubuntu 20.04 or Ubuntu 22.04. Script `./tools/docker.sh` creates Docker
container `ssi-u20` or `ssi-u22` which features g++ and clang++ compilers.
The build may be sped up using `ccache`. The project also makes use of
`clang-format` and `clang-tidy` to ensure better code style and quality.
As a build system, [Meson](https://mesonbuild.com/) is used. In my optinion,
it provides much more logical and cleaner DSL than [CMake](https://cmake.org)
does. The project documentation is created with [Doxygen](https://doxygen.nl/).

### Some instructions

Create Docker image and container if that hasn't been done yet,
execute bash in the container (requires Docker 18.09 or higher):
```
host_promtp> git clone git@github.com:ktrushin/ssi.git
host_prompt> cd ssi
host_prompt> ./tools/docker.sh -v 22.04
```
The rest of the instructions are executed in the container.

Run the formatter and the linter:
```
container_prompt> git add <changed files>
container_prompt> git-clang-format
container_prompt> <examine_the_changes>
container_prompt> git add <files_formatted_with_clang_format>
container_prompt>
container_prompt> ./tools/clang-tidy.sh
```

Compile the project with g++ and execute the resulting binary:
```
container_prompt> CXX='ccache g++' meson -Db_asneeded=false _build_gcc
container_prompt> ninja -v -C _build_gcc -j$(nproc)
container_prompt> ./_build_gcc/bin/ssi
Number of threads: 4
Local time: 2022-Set-04 15:20:53
```

Compile the project with clang++ and execute the resulting binary:
```
container_prompt> CXX='ccache clang++' meson -Db_asneeded=false _build_clang
container_prompt> ninja -v -C _build_clang -j$(nproc)
container_prompt> ./_build_clang/bin/ssi
Number of threads: 4
Local time: 2022-Sep-04 15:21:20
```

Install and uninstall:
```
container_prompt> sudo ninja -v -C _build_gcc install
container_prompt> sudo ldconfig
container_prompt> type ssi
ssi is /usr/local/bin/ssi
container_prompt> ssi
Number of threads: 4
Local time: 2022-Sep-04 15:23:17
container_prompt> sudo ninja -v -C _build_gcc uninstall
container_prompt> type ssi
ssi is hashed (/usr/local/bin/ssi)
container_prompt> hash -r
container_prompt> type ssi
bash: type: ssi: not found
```

Build, install and uninstall Debian packages:
```
container_prompt> ./tools/build_deb.sh -o "-uc -us"
<lots of output here>
container_prompt> ls _build_deb/
libssi0_0.1.0-1_amd64.deb          ssi_0.1.0-1_amd64.changes
libssi0-dbgsym_0.1.0-1_amd64.ddeb  ssi_0.1.0-1_amd64.deb
libssi-dev_0.1.0-1_amd64.deb       ssi_0.1.0-1.debian.tar.xz
libssi-doc_0.1.0-1_all.deb         ssi_0.1.0-1.dsc
ssi-0.1.0-1                        ssi-0.1.0-1.tar.gz
ssi_0.1.0-1_amd64.build            ssi_0.1.0.orig.tar.gz
ssi_0.1.0-1_amd64.buildinfo        ssi-dbgsym_0.1.0-1_amd64.ddeb
container_prompt> cd _build_deb
container_prompt> sudo dpkg -i libssi0_0.1.0-1_amd64.deb ssi_0.1.0-1_amd64.deb
container_prompt> type ssi
ssi is /usr/bin/ssi
container_prompt> ssi
Number of threads: 4
Local time: 2022-Sep-04 15:29:42
container_prompt> sudo apt-get purge ssi libssi0
container_prompt> type ssi
ssi is hashed (/usr/bin/ssi)
container_prompt> hash -r
container_prompt> type ssi
bash: type: ssi: not found
```

Although the project is created to be used mostly by the author as
a source of examples for setting up a development environment,
writing Meson build files and preparing Debian packages,
others may also find it useful.
