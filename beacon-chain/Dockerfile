ARG UPSTREAM_VERSION
FROM sigp/lighthouse:${UPSTREAM_VERSION}-modern

ARG NETWORK
ARG STAKER_SCRIPTS_VERSION
ARG DATA_DIR

ENV JWT_FILE_PATH=/jwtsecret \
    DATA_DIR=${DATA_DIR} \
    BEACON_API_PORT=3500 \
    NETWORK=${NETWORK} \
    STAKER_SCRIPTS_URL=https://github.com/dappnode/staker-package-scripts/releases/download/${STAKER_SCRIPTS_VERSION}

COPY jwtsecret.hex ${JWT_FILE_PATH}
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ADD ${STAKER_SCRIPTS_URL}/consensus_tools.sh /etc/profile.d/

RUN chmod +rx /usr/local/bin/entrypoint.sh /etc/profile.d/consensus_tools.sh

RUN apt-get update && apt-get install curl --yes && apt-get clean

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
