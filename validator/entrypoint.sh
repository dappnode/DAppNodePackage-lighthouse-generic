#!/bin/sh

SUPPORTED_NETWORKS="gnosis holesky mainnet"
MEVBOOST_FLAG="--builder-proposals"
SKIP_MEVBOOST_URL="true"
CLIENT="lighthouse"

handle_doppelganger() {
    # If ENABLE_DOPPELGANGER != false, then enable it
    if [ "${ENABLE_DOPPELGANGER}" != "false" ]; then
        echo "[INFO - entrypoint] Doppelganger protection is enabled"
        add_flag_to_extra_opts "--enable-doppelganger-protection"
    else
        echo "[WARN - entrypoint] Doppelganger protection is disabled"
    fi
}

# shellcheck disable=SC1091
. /etc/profile

run_validator() {
    echo "Starting validator..."

    # shellcheck disable=SC2086
    exec lighthouse \
        --debug-level="${LOG_LEVEL}" \
        --network="${NETWORK}" \
        validator \
        --init-slashing-protection \
        --datadir "${DATA_DIR}" \
        --beacon-nodes "${BEACON_API_URL}" \
        --graffiti="${GRAFFITI}" \
        --http \
        --http-address 0.0.0.0 \
        --http-port "${VALIDATOR_PORT}" \
        --http-allow-origin "*" \
        --unencrypted-http-transport \
        --metrics \
        --metrics-address 0.0.0.0 \
        --metrics-port 8008 \
        --metrics-allow-origin "*" \
        --suggested-fee-recipient="${FEE_RECIPIENT}" ${EXTRA_OPTS}
}

handle_doppelganger
format_graffiti
set_validator_config_by_network "${NETWORK}" "${SUPPORTED_NETWORKS}" "${CLIENT}"
set_mevboost_flag "${MEVBOOST_FLAG}" "${SKIP_MEVBOOST_URL}" # MEV-Boost: https://chainsafe.github.io/lodestar/usage/mev-integration/
run_validator
