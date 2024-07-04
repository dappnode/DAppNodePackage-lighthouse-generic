ARG UPSTREAM_VERSION
FROM sigp/lighthouse:${UPSTREAM_VERSION}-modern

ARG NETWORK
ARG STAKER_SCRIPTS_VERSION

COPY jwtsecret.hex /jwtsecret
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENV JWT_SECRET_FILE=/jwtsecret \
    DATA_DIR=/root/.lighthouse \
    BEACON_API_PORT=3500 \
    NETWORK=${NETWORK} \
    STAKER_SCRIPTS_URL=https://github.com/dappnode/staker-package-scripts/releases/download/${STAKER_SCRIPTS_VERSION}

ADD ${STAKER_SCRIPTS_URL}/consensus_tools.sh /etc/profile.d/

RUN chmod +rx /usr/local/bin/entrypoint.sh /etc/profile.d/consensus_tools.sh

RUN apt-get update && apt-get install curl --yes && apt-get clean

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
