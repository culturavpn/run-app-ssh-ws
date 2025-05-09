FROM python:2.7-alpine

# Instalar dependencias necesarias
RUN apk update && apk add --no-cache \
    dropbear \
    curl \
    gcc \
    libffi-dev \
    libssl-dev \
    python-dev \
    musl-dev \
    && pip install paramiko \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario para autenticación SSH
RUN adduser -D -s /bin/bash docker && echo "docker:docker123" | chpasswd

# Crear carpetas necesarias para Dropbear
RUN mkdir -p /etc/dropbear /var/run/dropbear

# Asegurarse de que Dropbear tenga la shell por defecto
RUN echo "/bin/bash" >> /etc/shells

# Directorio de trabajo
WORKDIR /app

# Descargar el script WebSocket
RUN curl -o websocket973.py https://raw.githubusercontent.com/nube50/SshWs8080/refs/heads/main/websocket973.py

# Establecer permisos de ejecución si fuera necesario
RUN chmod +x websocket973.py

# Cloud Run usa PORT (aunque usaremos 8080 como valor)
ENV PORT=8080
EXPOSE 8080

# Agregar logs de Dropbear y del script Python

# Ejecutar Dropbear y capturar sus logs
CMD (echo "Iniciando Dropbear..." && dropbear -E -F -p 22 -v) & (echo "Ejecutando websocket973.py..." && python websocket973.py 8080)
