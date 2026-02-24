#!/bin/bash

# Get log file path from manifest
# The h-manifest.conf is sourced by the calling script, so its variables are available here.
LOG_FILE="$CUSTOM_LOG_BASENAME.log"
LOG_DIR=$(dirname "$LOG_FILE")

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# --- Shutdown/Cleanup Function ---
# This function will be called by the trap command when the script receives a signal
cleanup() {
  echo "--- h-run.sh: Caught exit signal, running cleanup... ---"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - h-run.sh received stop signal. Stopping Nosana..." >> "$LOG_FILE"
  # The Nosana process is a child of this script and should receive the signal as well.
  # We just need to exit gracefully.
  rm -f /tmp/nosana_wrapper.sh
  rm -f /tmp/nosana_start.sh
  echo "--- h-run.sh: Exiting now. ---"
  exit 0
}

# --- Trap Exit Signals ---
# This ensures the cleanup function is called when HiveOS stops the miner
trap 'cleanup' SIGTERM SIGHUP SIGINT SIGQUIT EXIT

# --- Main Execution ---
echo "--- h-run.sh: Starting miner process... ---"

# Create a wrapper script to handle the download and execution
cat << 'EOF' > /tmp/nosana_wrapper.sh
#!/bin/bash
export HOME=/root

# Enable verbose logging for debugging
set -x

# Download start.sh
if wget -qO /tmp/nosana_start.sh https://nosana.com/start.sh; then
  # Remove TTY allocation from docker exec command
  sed -i 's/docker exec -it/docker exec -i/g' /tmp/nosana_start.sh
  # Remove TTY allocation from DOCKER_ARGS
  sed -i 's/--interactive -t/--interactive/g' /tmp/nosana_start.sh

  # Run the patched script
  bash /tmp/nosana_start.sh
else
  echo "Failed to download start.sh"
  exit 1
fi
EOF
chmod +x /tmp/nosana_wrapper.sh

echo "$(date '+%Y-%m-%d %H:%M:%S') - h-run.sh starting Nosana..." >> "$LOG_FILE"

# Run the wrapper script in the background and redirect output to log file
sg docker -c /tmp/nosana_wrapper.sh >> "$LOG_FILE" 2>&1 &

# --- Keep Script Alive ---
# This loop is required to keep the script running so HiveOS doesn't think it crashed.
# The actual miner process is running in the background.
while true
do
  sleep 5
done
