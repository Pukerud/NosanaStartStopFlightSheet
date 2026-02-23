# Nosana Flight Sheet for HiveOS

This repository contains a set of scripts to run a Nosana node as a custom miner in HiveOS.

## Overview

These scripts provide a simple way to integrate a Nosana node with HiveOS, allowing you to use a Flight Sheet to start, stop, and monitor the node.

## Features

- **Full HiveOS Integration:** Uses the modern `h-manifest.conf` method for custom miners.
- **Clean Start/Stop:** Reliably starts the Nosana node when the flight sheet is launched and stops it when the flight sheet is stopped.
- **Logging:** Creates a log file for debugging purposes at `/var/log/nosana-flight-sheet.log`.
- **Basic Stats:** Reports basic uptime and a dummy hashrate to the HiveOS agent.

## Installation and Usage

1.  **Create a .tar.gz package:**
    The tarball must contain a directory named `NosanaSheet` containing the miner files.

    **Linux / macOS / WSL:**
    ```bash
    mkdir -p NosanaSheet
    cp h-manifest.conf h-config.sh h-run.sh h-stats.sh README.md NosanaSheet/
    tar -czvf NosanaSheet.tar.gz NosanaSheet/
    rm -rf NosanaSheet
    ```

    **Windows (Command Prompt):**
    ```cmd
    mkdir NosanaSheet
    copy h-manifest.conf NosanaSheet\
    copy h-config.sh NosanaSheet\
    copy h-run.sh NosanaSheet\
    copy h-stats.sh NosanaSheet\
    copy README.md NosanaSheet\
    tar -czvf NosanaSheet.tar.gz NosanaSheet
    rmdir /s /q NosanaSheet
    ```

    **Windows (PowerShell):**
    ```powershell
    New-Item -ItemType Directory -Force -Path NosanaSheet
    Copy-Item h-manifest.conf, h-config.sh, h-run.sh, h-stats.sh, README.md -Destination NosanaSheet
    tar -czvf NosanaSheet.tar.gz NosanaSheet
    Remove-Item -Recurse -Force NosanaSheet
    ```

2.  **Upload the package:**
    -   Upload the `NosanaSheet.tar.gz` file to a web server or a service like GitHub releases. You will need a public URL to the file.
3.  **Configure the HiveOS Flight Sheet:**
    -   In HiveOS, create a new Flight Sheet.
    -   For the miner, select "Custom".
    -   Click "Setup Miner Config".
    -   A new window will appear. Fill in the following fields:
        -   **Miner name:** `NosanaSheet`
        -   **Installation URL:** The public URL to your `NosanaSheet.tar.gz` file.
    -   Apply changes, save the flight sheet, and launch it.

## Troubleshooting

-   The primary log file for this flight sheet is located on your rig at `/var/log/nosana-flight-sheet.log`. If the miner starts but the Nosana node doesn't, check this log first.
