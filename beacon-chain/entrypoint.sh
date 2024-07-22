#!/bin/sh

SUPPORTED_NETWORKS="gnosis holesky mainnet"
CHECKPOINT_SYNC_FLAG="--checkpoint-sync-url"
MEVBOOST_FLAG_KEYS="--builder"

# shellcheck disable=SC1091 # Path is relative to the Dockerfile
. /etc/profile

ENGINE_URL=$(get_engine_api_url "${NETWORK}" "${SUPPORTED_NETWORKS}")
VALID_FEE_RECIPIENT=$(get_valid_fee_recipient "${FEE_RECIPIENT}")
CHECKPOINT_SYNC_FLAG=$(get_checkpoint_sync_flag "${CHECKPOINT_SYNC_FLAG}" "${CHECKPOINT_SYNC_URL}")
MEVBOOST_FLAG=$(get_mevboost_flag "${NETWORK}" "${MEVBOOST_FLAG_KEYS}")

EXTRA_OPTS=$(add_flag_to_extra_opts_safely "${EXTRA_OPTS}" "--checkpoint-sync-url-timeout=300")
EXTRA_OPTS=$(add_flag_to_extra_opts_safely "${EXTRA_OPTS}" "--suggested-fee-recipient=${VALID_FEE_RECIPIENT}")

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
    --execution-endpoint "${ENGINE_URL}" \
    --execution-jwt "${JWT_FILE_PATH}" ${CHECKPOINT_SYNC_FLAG} ${MEVBOOST_FLAG} ${EXTRA_OPTS}
