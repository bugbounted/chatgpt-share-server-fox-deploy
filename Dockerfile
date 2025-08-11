FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install required packages: mysql, redis, openjdk, supervisor, nginx, wget, curl
RUN apt-get update && apt-get install -y \
    mysql-server \
    redis-server \
    openjdk-17-jre-headless \
    supervisor \
    nginx \
    wget \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Copy your AI service configs and data folders
COPY ./data/mysql/ /var/lib/mysql/
COPY ./docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/

COPY ./data/redis/ /data/redis/

COPY ./gpt_config.yaml /app/chatgpt-share-server/config.yaml
COPY ./data/chatgpt-share-server/ /app/chatgpt-share-server/data/

COPY ./grok_config.yaml /app/grok-share-server/config.yaml
COPY ./data/grok-share-server/ /app/grok-share-server/data/

COPY ./claude_config.yaml /app/dddd-share-server/config.yaml
COPY ./data/dddd-share-server/ /app/dddd-share-server/data/

COPY ./data/chatgpt-share-server-fox/ /data/chatgpt-share-server-fox/

# Copy start scripts into /app
COPY ./start_gpt.sh /app/start_gpt.sh
COPY ./start_grok.sh /app/start_grok.sh
COPY ./start_ddd.sh /app/start_ddd.sh

# Make start scripts executable
RUN chmod +x /app/start_gpt.sh /app/start_grok.sh /app/start_ddd.sh

# Copy supervisord and nginx config files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Expose only one port externally
EXPOSE 5000

CMD ["/usr/bin/supervisord", "-n"]
