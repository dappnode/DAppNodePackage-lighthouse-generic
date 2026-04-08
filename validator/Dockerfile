FROM --platform=$TARGETPLATFORM alpine:3.20 AS curl-stage
RUN apk add --no-cache curl

ARG UPSTREAM_VERSION
FROM sigp/lighthouse:${UPSTREAM_VERSION}

ARG NETWORK
ARG STAKER_SCRIPTS_VERSION
ARG DATA_DIR

COPY security/api-token.txt /root/.lighthouse/validators/
COPY security/.secp-sk /root/.lighthouse/validators/
COPY entrypoint.sh /usr/local/bin

ENV VALIDATOR_PORT=3500 \
    DATA_DIR=${DATA_DIR} \
    STAKER_SCRIPTS_URL=https://github.com/dappnode/staker-package-scripts/releases/download/${STAKER_SCRIPTS_VERSION}

ADD ${STAKER_SCRIPTS_URL}/consensus_tools.sh /etc/profile.d/

COPY --from=curl-stage /usr/bin/curl /usr/bin/curl
RUN chmod +rx /usr/local/bin/entrypoint.sh /etc/profile.d/consensus_tools.sh

# This env changes the variant
# Placed at the end to regenerate the least amount of layers
ENV NETWORK=${NETWORK}

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
