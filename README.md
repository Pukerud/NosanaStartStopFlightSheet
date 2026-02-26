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
    
  if you manually make the miner remember to chmod all the files
  "cd /hive/miners/custom" and make a tar file : "tar -czvf NosanaFlight.tar.gz NosanaFlight/"
  run this to upload: 
  "scp user@YOUR_RIG_IP:/hive/miners/custom/NosanaFlight.tar.gz %USERPROFILE%\Desktop\"

2.  **Upload the package:**
    -   Upload the `NosanaFlight.tar.gz` file to a web server or a service like GitHub releases. You will need a public URL to the file.
    -   **Tip:** When releasing a new version, change the filename (e.g., `NosanaFlight-v1.tar.gz`, `NosanaFlight-v2.tar.gz`) to ensure HiveOS downloads the new version instead of using a cached one.

3.  **Configure the HiveOS Flight Sheet:**
    -   In HiveOS, create a new Flight Sheet.
    -   For the miner, select "Custom".
    -   Click "Setup Miner Config".
    -   A new window will appear. Fill in the following fields:
        -   **Miner name:** `NosanaFlight` (Must match the directory name inside the tarball)
        -   **Installation URL:** The public URL to your `.tar.gz` file.
    -   Apply changes, save the flight sheet, and launch it.

## Troubleshooting

-   The primary log file for this flight sheet is located on your rig at `/var/log/nosana-flight-sheet.log`. If the miner starts but the Nosana node doesn't, check this log first.
