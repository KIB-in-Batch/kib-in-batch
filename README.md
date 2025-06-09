# Kali in Batch

Kali in Batch is a software that allows you to run a fake Kali Linux environment on Windows, using Batch, PowerShell, Busybox and Bash.

## Installation

You can do two things:

1. Download the latest kali_in_batch.zip or kali_in_batch.tar.gz from the [Releases](https://github.com/Kali-in-Batch/kali-in-batch/releases) page. These archives already bundle Busybox, Bash and the Msys runtime and are created using a [GitHub workflow](./.github/workflows/upload_src_to_release.yml)

2. Clone the repository and run setup.bat.

## How it works

Kali in Batch bundles portable versions of Busybox, Bash and the Msys runtime, allowing for a POSIX environment to run on Windows.

Some commands, like `cat`, `ls`, `echo` and `ls` are reimplemented in pure Batch.
<!-- Yes. ls is listed twice. You can make a pull request to fix that. -->

The actual shell is written in PowerShell, and the bootloader and installer is written in Batch.

## Downloads

[![zip](https://img.shields.io/badge/release-kali__in__batch.zip-blue?style=for-the-badge&logo=github)](https://github.com/Kali-in-Batch/kali-in-batch/releases/latest/download/kali_in_batch.zip)
[![tar.gz](https://img.shields.io/badge/release-kali__in__batch.tar.gz-green?style=for-the-badge&logo=github)](https://github.com/Kali-in-Batch/kali-in-batch/releases/latest/download/kali_in_batch.tar.gz)

[![Development branch](https://img.shields.io/badge/branch-dev-blue?style=for-the-badge&logo=github)](https://github.com/Kali-in-Batch/kali-in-batch/archive/refs/heads/dev.zip)
[![Stable branch](https://img.shields.io/badge/branch-master-green?style=for-the-badge&logo=github)](https://github.com/Kali-in-Batch/kali-in-batch/archive/refs/heads/master.zip)