FROM ysicing/debian

# 安装 Node.js 20 + 常用工具
RUN set -x \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        nodejs \
        jq \
        ripgrep \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# 安装 AI 代码评审工具
RUN npm install -g \
        @anthropic-ai/claude-code \
        @openai/codex
