#!/bin/sh

SUPPORTED_NETWORKS="gnosis hoodi mainnet"
MEVBOOST_FLAG_KEY="--builder-proposals"
SKIP_MEVBOOST_URL="true"
CLIENT="lighthouse"

# shellcheck disable=SC1091
. /etc/profile

VALID_GRAFFITI=$(get_valid_graffiti "${GRAFFITI}")
VALID_FEE_RECIPIENT=$(get_valid_fee_recipient "${FEE_RECIPIENT_ADDRESS}")
BEACON_API_URL=$(get_beacon_api_url "${NETWORK}" "${SUPPORTED_NETWORKS}" "${CLIENT}")
MEVBOOST_FLAG=$(get_mevboost_flag "${NETWORK}" "${MEVBOOST_FLAG_KEY}" "${SKIP_MEVBOOST_URL}")

if [ "${ENABLE_DOPPELGANGER}" != "false" ]; then
    echo "[INFO - entrypoint] Doppelganger protection is enabled"
    EXTRA_OPTS=$(add_flag_to_extra_opts_safely "${EXTRA_OPTS}" "--enable-doppelganger-protection")
else
    echo "[WARN - entrypoint] Doppelganger protection is disabled"
fi

FLAGS="--debug-level=$LOG_LEVEL \
    --network=$NETWORK \
    validator \
    --init-slashing-protection \
    --datadir=$DATA_DIR \
    --beacon-nodes=$BEACON_API_URL \
    --graffiti=$VALID_GRAFFITI \
    --http \
    --http-address 0.0.0.0 \
    --http-port=$VALIDATOR_PORT \
    --http-allow-origin=* \
    --unencrypted-http-transport \
    --metrics \
    --metrics-address=0.0.0.0 \
    --metrics-port=8008 \
    --metrics-allow-origin=* \
    --suggested-fee-recipient=$VALID_FEE_RECIPIENT ${MEVBOOST_FLAG} ${EXTRA_OPTS}"

echo "[INFO - entrypoint] Starting lighthouse validator with flags: $FLAGS"

# shellcheck disable=SC2086
exec lighthouse $FLAGS
