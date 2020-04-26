FROM nodered/node-red:latest-12-minimal

# Copy in our scripts and make them executable.
USER root
COPY scripts/ scripts
RUN chmod +x -R scripts

USER node-red

ENTRYPOINT scripts/entrypoint.sh
