FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar Dropbear, Python 2, pip y herramientas necesarias
RUN apt-get update && apt-get install -y \
    dropbear \
    python2 \
    python-pip \
    curl \
    bash \
    build-essential \
    libffi-dev \
    libssl-dev \
    && pip install paramiko \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario 'docker' con contraseña 'docker123'
RUN useradd -m -s /bin/bash docker && echo 'docker:docker123' | chpasswd

# Habilitar autenticación por contraseña en Dropbear (por defecto lo permite)
RUN mkdir -p /etc/dropbear /var/run/dropbear && \
    echo "/bin/bash" >> /etc/shells

# Establecer el nuevo directorio de trabajo
WORKDIR /app50

# Descargar el script Python
RUN curl -o websocket973.py https://raw.githubusercontent.com/nube50/SshWs8080/refs/heads/main/websocket973.py
RUN chmod +x websocket973.py

# Exponer solo el puerto WebSocket
EXPOSE 8080

# Ejecutar Dropbear en segundo plano y el script Python como principal
CMD /usr/sbin/dropbear -E -F -p 22 & python2 websocket973.py 8080
