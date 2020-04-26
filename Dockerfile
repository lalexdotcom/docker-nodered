FROM nodered/node-red:latest-12-minimal

RUN mv package.json package.docker.json
COPY package.json .
RUN npm install  --no-package-lock
RUN mv package.json package.build.json
RUN cp package.docker.json package.json

RUN ls -l node_modules/node-red*

# Copy in our scripts and make them executable.
USER root
COPY scripts/ scripts
RUN chmod +x -R scripts

USER node-red

ENTRYPOINT scripts/entrypoint.sh
