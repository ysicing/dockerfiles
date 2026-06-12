FROM ysicing/god

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt install -y nodejs

RUN corepack enable && corepack prepare pnpm@latest --activate


