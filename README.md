# Example Common Form Build Configuration

This repository contains files for building forms in various formats from a Common Form Markdown source file.

## Prerequisites

You will need _either_ [Make], [npm], and [unoconv] _or_ another system with [Docker].

[Make]: https://www.gnu.org/software/make/

[npm]: https://docs.npmjs.com/cli/npm

[unoconv]: https://github.com/unoconv/unoconv

[Docker]: https://docker.com

To build with locally installed tools, run `make`.  To build in a Docker container, run `make docker`.

## Source Files

[`nda.md`](./nda.md) contains the text of the form in [Common Form Markdown format](https://type.commonform.org).

The build configuration will detect and build forms from any files with the '.md` extension.

## Configuration Files

[`Makefile`](./Makefile) configures GNU [Make] to build and check forms in the same directory, writing new files to a `build` subdirectory.  Run `make` in the directory to build, `make lint` to check for structural errors, and `make critique` to critique usage.  Users on Windows or OS X may have better luck with `make docker`, which runs on Linux with [Docker].

[`package.json`](./package.json) configures [npm] to download Common Form build tools.

[`package-lock.json`](./package-lock.json) configures npm to download specific versions of the build tools, so the process of building the forms is repeatable.

[`styles.json`](./styles.json) configures formatting by the Common Form Microsoft Word build tool.

[`.gitignore`](./gitignore) configures Git to ignore built files in the `build` subdirectory.

[`Dockerfile`](./Dockerfile) configures [Docker].
