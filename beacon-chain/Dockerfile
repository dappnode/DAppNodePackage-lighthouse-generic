ARG UPSTREAM_VERSION
FROM sigp/lighthouse:${UPSTREAM_VERSION}-modern

ARG NETWORK
ARG STAKER_SCRIPTS_VERSION
ARG DATA_DIR
ARG P2P_PORT

ENV JWT_FILE_PATH=/jwtsecret \
    DATA_DIR=${DATA_DIR} \
    BEACON_API_PORT=3500 \
    P2P_PORT=${P2P_PORT} \
    STAKER_SCRIPTS_URL=https://github.com/dappnode/staker-package-scripts/releases/download/${STAKER_SCRIPTS_VERSION}

COPY jwtsecret.hex ${JWT_FILE_PATH}
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ADD ${STAKER_SCRIPTS_URL}/consensus_tools.sh /etc/profile.d/

RUN apt-get update && apt-get --yes install curl && apt-get clean && \
    chmod +rx /usr/local/bin/entrypoint.sh /etc/profile.d/consensus_tools.sh

# This env changes the variant
# Placed at the end to regenerate the least amount of layers
ENV NETWORK=${NETWORK}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
