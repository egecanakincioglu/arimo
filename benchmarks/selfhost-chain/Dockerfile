FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash python3 coreutils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY run-chain.sh /workspace/run-chain.sh
RUN chmod +x /workspace/run-chain.sh

ENTRYPOINT ["/workspace/run-chain.sh"]
