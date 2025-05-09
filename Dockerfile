FROM alpine:3.18

# Instalar dependencias necesarias
RUN apk update && apk add --no-cache \
    dropbear \
    python2 \
    py2-pip \
    curl \
    bash \
    shadow \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python2-dev \
    make \
    && pip install paramiko

# Crear usuario y contraseña
RUN adduser -D docker && echo "docker:docker123" | chpasswd

# Crear carpetas necesarias para Dropbear
RUN mkdir -p /etc/dropbear /var/run/dropbear
RUN echo "/bin/bash" >> /etc/shells

# Directorio de trabajo
WORKDIR /app

# Descargar script
RUN curl -o websocket973.py https://raw.githubusercontent.com/nube50/SshWs8080/refs/heads/main/websocket973.py
RUN chmod +x websocket973.py

# Exponer solo el puerto WebSocket
EXPOSE 8080

# Ejecutar Dropbear (SSH) en segundo plano y el script como proceso principal
CMD echo "Iniciando Dropbear SSH..." && \
    dropbear -E -F -p 22 -v & \
    echo "Ejecutando websocket973.py..." && \
    python2 websocket973.py 8080
