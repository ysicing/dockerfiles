FROM ysicing/god

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt install -y nodejs

RUN corepack enable && corepack prepare pnpm@latest --activate

RUN npm install -g bun && bun --version

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

RUN uv --version && uvx --version
