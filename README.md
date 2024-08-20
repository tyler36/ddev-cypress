# DDEV-cypress <!-- omit in toc -->

[![tests](https://github.com/tyler36/ddev-cypress/actions/workflows/tests.yml/badge.svg)](https://github.com/tyler36/ddev-cypress/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2025.svg)
- [Introduction](#introduction)
- [Requirements](#requirements)
- [Steps](#steps)
  - [Configure `DISPLAY`](#configure-display)
    - [Windows 10](#windows-10)
      - [Running DDEV on Win10 (not WSL)](#running-ddev-on-win10-not-wsl)
  - [A note about the Cypress image](#a-note-about-the-cypress-image)
- [Commands](#commands)
  - [`cypress-open`](#cypress-open)
  - [`cypress-run`](#cypress-run)
- [Notes](#notes)
- [Troubleshooting](#troubleshooting)
  - ["Could not find a Cypress configuration file, exiting"](#could-not-find-a-cypress-configuration-file-exiting)
  - ["Unable to open X display."](#unable-to-open-x-display)

## Introduction

[Cypress](https://www.cypress.io/) is a "complete end-to-end testing experience". It allows you to write JavaScript test files that automate real browsers. For more details, see the [Cypress Overview](https://docs.cypress.io/guides/overview/why-cypress) page.

This recipe integrates a Cypress docker image with your DDEV project.

## Requirements

- DDEV >= 1.19
- Modern OS
  - MacOS 10.9 and above (Intel or Apple Silicon 64-bit (x64 or arm64))
  - Linux Ubuntu 12.04 and above, Fedora 21 and Debian 8 (x86_64 or Arm 64-bit (x64 or arm64))
  - Windows 7 and above (64-bit)
- Interactive mode requires a X11 server running on the host machine.

## Steps

- Install service

  ```shell
  ddev get tyler36/ddev-cypress
  ddev restart
  ```

- Run cypress via `ddev cypress-open` or `ddev cypress-run` (headless).

We recommend running `ddev cypress-open` first to create configuration and support files.
This addon sets `CYPRESS_baseUrl` to DDEV's primary URL in the `docker-compose.cypress.yaml`.

### Configure `DISPLAY`

To display the Cypress screen and browser output, you must configure a `DISPLAY` environment variable.

#### Linux

You may need to set up access control for the X server for this to work. Install the xhost package (one is available for all distros) and run:

```sh
export DISPLAY=:0.0
xhost +local:docker
```

#### Windows 10

If you are running DDEV on Win10 or WSL2, you need to configure a display server on Win10.
You are free to use any X11-compatible server. A configuration-free solution is to install [GWSL via the Windows Store](https://www.microsoft.com/en-us/p/gwsl/9nl6kd1h33v3#activetab=pivot:overviewtab).

##### Running DDEV on Win10 (not WSL)

- Install [GWSL via the Windows Store](https://www.microsoft.com/en-us/p/gwsl/9nl6kd1h33v3#activetab=pivot:overviewtab)
- Get you "IPv4 Address" for your "Ethernet adapter" via networking panel or by typing `ipconfig` in a terminal. The address in the below example is `192.168.0.196`

```shell
❯ ipconfig

Windows IP Configuration


Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . :
   IPv4 Address. . . . . . . . . . . : 192.168.0.196
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 192.168.0.1
```

- In your project `./docker-compose.cypress.yaml`, add the IPv4 address and `:0` (For example `192.168.0.196:0` ) to the display section under environment.

```yaml
    environment:
      - DISPLAY=192.168.0.196:0
```

### A note about the Cypress image

This recipe uses the latest `cypress/include` image which includes the following browsers:

- Chrome
- Firefox
- Electron

Best practice encourages using a [specific image tag](https://github.com/cypress-io/cypress-docker-images#best-practice).

- If you require a specific browser, update `image` in your `./.ddev/docker-compose.cypress.yaml`.
- Available images and versions are available on the [cypress-docker-images](https://github.com/cypress-io/cypress-docker-images) page.

## Commands

Cypress can run into 2 different modes: interactive and runner.
This recipe includes 2 alias commands to help you use Cypress.

To see Cypress in interactive mode, Cypress forward XVFB messages out of the Cypress container into an X11 server running on the host machine. Each OS has different options. Developers have reported success with the following:

- Windows 10 / WSL users:
  - [GWSL](https://opticos.github.io/gwsl/tutorials/manual.html) (via [Microsoft store](ms-windows-store://pdp/?productid=9NL6KD1H33V3))
  - [VcXsrv](https://sourceforge.net/projects/vcxsrv/) (via [chocolatey](https://community.chocolatey.org/packages/vcxsrv#versionhistory)).
- Mac users:
  - [XQuartz](https://www.xquartz.org/). See [Running GUI applications using Docker for Mac](https://sourabhbajaj.com/blog/2017/02/07/gui-applications-docker-mac/).

### `cypress-open`

To open cypress in "interactive" mode, run the following command:

```shell
ddev cypress-open
```

See ["#cypress open" documentation](https://docs.cypress.io/guides/guides/command-line#cypress-open) for a full list of available arguments.

Example: To open Cypress in interactive mode, and specify a config file

```shell
ddev cypress-open --config cypress.json
```

### `cypress-run`

To run Cypress in "runner" mode, run the following command:

```shell
ddev cypress-run
```

See [#cypress run](https://docs.cypress.io/guides/guides/command-line#cypress-run) for a full list of available arguments.

Example: To run all Cypress tests, using Chrome in headless mode

```shell
ddev cypress-run --browser chrome
```

## Notes

- The dockerized Cypress *should* find any locally installed plugins in your project's `node_modules`; assuming they are install via npm or yarn.
- Some plugins may require specific settings, such as environmental variables. Pass them through via command arguments.

## Troubleshooting

### "Could not find a Cypress configuration file, exiting"

Cypress expects a directory structures containing the tests, plugins and support files.

- If the `./cypress` directory does not exist, it will scaffold out these directories, including a default `cypress.json` setting file and example tests when you first run `ddev cypress-open`.
- Make sure you have a `cypress.json` file in your project root, or use `--config [file]` argument to specify one.

### "Unable to open X display."

- This recipe forwards the Cypress GUI via an X11 / X410 server. Please ensure you have this working on your host system.

**Contributed by [@tyler36](https://github.com/tyler36)**
