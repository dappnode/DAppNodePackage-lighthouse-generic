#!/bin/sh

SUPPORTED_NETWORKS="gnosis holesky mainnet"
CHECKPOINT_SYNC_FLAG="--checkpoint-sync-url"
MEVBOOST_FLAGS="--builder"

# shellcheck disable=SC1091 # Path is relative to the Dockerfile
. /etc/profile

run_beacon() {
    echo "[INFO - entrypoint] Starting beacon node..."

    # shellcheck disable=SC2086
    exec lighthouse \
        --debug-level "${LOG_LEVEL}" \
        --network "${NETWORK}" \
        beacon_node \
        --datadir="${DATA_DIR}" \
        --http \
        --http-allow-origin "*" \
        --http-address 0.0.0.0 \
        --http-port "${BEACON_API_PORT}" \
        --port "${P2P_PORT}" \
        --metrics \
        --metrics-address 0.0.0.0 \
        --metrics-port 8008 \
        --metrics-allow-origin "*" \
        --execution-endpoint "${ENGINE_API_URL}" \
        --execution-jwt "${JWT_SECRET_FILE}" \
        ${EXTRA_OPTS}
}

add_flag_to_extra_opts "--checkpoint-sync-url-timeout=300"
set_beacon_config_by_network "${NETWORK}" "${SUPPORTED_NETWORKS}"
set_checkpointsync_url "${CHECKPOINT_SYNC_FLAG}" "${CHECKPOINT_SYNC_URL}"
set_mevboost_flag "${MEVBOOST_FLAGS}" # MEV-Boost: https://chainsafe.github.io/lodestar/usage/mev-integration/
run_beacon
