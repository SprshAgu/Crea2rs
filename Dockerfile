FROM node:22-bookworm-slim
ARG GODOT_VERSION=4.7.2
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl unzip libfontconfig1 libx11-6 libxcursor1 libxinerama1 libgl1 libxi6 libxrandr2 libasound2 libpulse0 && rm -rf /var/lib/apt/lists/*
RUN curl -fL --retry 3 "https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip" -o /tmp/godot.zip && unzip /tmp/godot.zip -d /tmp/godot && mv /tmp/godot/Godot* /usr/local/bin/godot && chmod +x /usr/local/bin/godot && rm -rf /tmp/godot /tmp/godot.zip
WORKDIR /app
COPY game-server.zip /tmp/game-server.zip
RUN unzip /tmp/game-server.zip -d /tmp/source && cp -a /tmp/source/godot-multiplayer/. /app/ && rm -rf /tmp/source /tmp/game-server.zip
RUN cd online-room-server && npm install --omit=dev
RUN godot --headless --editor --path /app --import
ENV GODOT_BIN=/usr/local/bin/godot GODOT_PROJECT=/app MAX_ROOMS=2
WORKDIR /app/online-room-server
USER node
CMD ["node", "server.js"]
