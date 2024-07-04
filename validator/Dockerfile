ARG UPSTREAM_VERSION
FROM sigp/lighthouse:${UPSTREAM_VERSION}-modern

ARG NETWORK
ARG STAKER_SCRIPTS_VERSION

COPY security/api-token.txt /root/.lighthouse/validators/
COPY security/.secp-sk /root/.lighthouse/validators/
COPY entrypoint.sh /usr/local/bin

ENV VALIDATOR_PORT=3500 \
    DATA_DIR=/root/.lighthouse \
    NETWORK=${NETWORK} \
    STAKER_SCRIPTS_URL=https://github.com/dappnode/staker-package-scripts/releases/download/${STAKER_SCRIPTS_VERSION}

ADD ${STAKER_SCRIPTS_URL}/consensus_tools.sh /etc/profile.d/

RUN chmod +rx /usr/local/bin/entrypoint.sh /etc/profile.d/consensus_tools.sh

RUN apt-get update && apt-get install curl --yes && apt-get clean

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
