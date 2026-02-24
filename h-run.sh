#!/bin/bash

LOG_FILE="$CUSTOM_LOG_BASENAME.log"
LOG_DIR=$(dirname "$LOG_FILE")
mkdir -p "$LOG_DIR"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting Nosana..." >> "$LOG_FILE"

# Create the wrapper script
cat << 'INNER_EOF' > /tmp/nosana_wrapper.sh
#!/bin/bash
export HOME=/root
set -x

if wget -qO /tmp/nosana_start.sh "https://nosana.com/start.sh"; then
  # Broadly remove TTY flags for both run and exec commands
  sed -i 's/docker exec -it/docker exec -i/g' /tmp/nosana_start.sh
  sed -i 's/docker run -it/docker run -i/g' /tmp/nosana_start.sh
  sed -i 's/ -it / -i /g' /tmp/nosana_start.sh
  sed -i 's/--interactive -t/--interactive/g' /tmp/nosana_start.sh

  bash /tmp/nosana_start.sh
else
  echo "Failed to download start.sh"
  exit 1
fi
INNER_EOF

chmod +x /tmp/nosana_wrapper.sh

# Run the wrapper in the background and log it
bash /tmp/nosana_wrapper.sh >> "$LOG_FILE" 2>&1 &

# Keep the script alive for HiveOS and stream the text to the live miner screen
tail -f "$LOG_FILE"
