FROM python:2.7-slim

# Instala Dropbear, curl y dependencias
RUN apt-get update && apt-get install -y \
    dropbear \
    curl \
    gcc \
    libffi-dev \
    libssl-dev \
    python-dev \
    && pip install paramiko \
    && rm -rf /var/lib/apt/lists/*

# Crea usuario SSH
RUN useradd -m docker && echo "thomas:cultura" | chpasswd

# Crea carpetas necesarias para Dropbear
RUN mkdir -p /etc/dropbear && mkdir -p /var/run/dropbear

# Directorio de trabajo
WORKDIR /app

# Descargar el script WebSocket
RUN curl -o websocket973.py https://raw.githubusercontent.com/nube50/SshWs8080/refs/heads/main/websocket973.py

# Exponer el puerto para WebSocket
ENV PORT=8080
EXPOSE 8080

# CMD que lanza Dropbear y el script Python (ambos en primer plano)
CMD dropbear -E -F -p 22 & python websocket973.py 8080
