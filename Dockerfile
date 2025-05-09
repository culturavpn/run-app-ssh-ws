FROM alpine:3.18

# Instalar dependencias necesarias
RUN apk update && apk add --no-cache \
    python2 \
    py2-pip \
    dropbear \
    curl \
    bash \
    openssh-keygen \
    shadow \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python2-dev \
    make \
    && pip install paramiko

# Crear usuario y contraseña para autenticación SSH
RUN useradd -m -s /bin/bash docker && echo "docker:docker123" | chpasswd

# Crear carpetas necesarias para Dropbear
RUN mkdir -p /etc/dropbear /var/run/dropbear

# Establecer shell válida para el usuario
RUN echo "/bin/bash" >> /etc/shells

# Directorio de trabajo
WORKDIR /app

# Descargar script WebSocket
RUN curl -o websocket973.py https://raw.githubusercontent.com/nube50/SshWs8080/refs/heads/main/websocket973.py

# Establecer permisos de ejecución
RUN chmod +x websocket973.py

# Exponer solo el puerto del websocket
EXPOSE 8080

# Comando final: iniciar Dropbear y luego el script
CMD echo "Iniciando Dropbear..." && \
    dropbear -E -F -p 22 -v & \
    echo "Ejecutando websocket973.py..." && \
    python2 websocket973.py 8080
