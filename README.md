# Kali in Batch

Kali in Batch is a software that allows you to run a fake Kali Linux environment on Windows, using Batch, PowerShell, Busybox and Bash.

## Installation

You can do two things:

1. Download the latest kali_in_batch.zip or kali_in_batch.tar.gz from the [Releases](https://github.com/Kali-in-Batch/kali-in-batch/releases) page. These archives already bundle Busybox, Bash and the Msys runtime and are created using a [GitHub workflow](./.github/workflows/upload_src_to_release.yml).

2. Clone the repository and run setup.bat.

## How it works

Kali in Batch bundles portable versions of Busybox, Bash and the Msys runtime, allowing for a POSIX environment to run on Windows.

Some commands, like `cat`, `ls`, `echo` and `ls` are reimplemented in pure Batch.

The actual shell is written in PowerShell, and the bootloader and installer are written in Batch.

## Releases

## Nightly builds

![Latest nightly build](https://img.shields.io/endpoint?url=https://kali-in-batch.github.io/kali-in-batch/prerelease.json&style=for-the-badge&color=blue)