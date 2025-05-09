FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar OpenSSH, Python 2 y otras herramientas necesarias
RUN apt-get update && apt-get install -y \
    openssh-server \
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

# Crear usuario con contraseña
RUN useradd -m -s /bin/bash docker && echo 'docker:docker123' | chpasswd

# Habilitar autenticación por contraseña en SSH
RUN mkdir -p /var/run/sshd
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Establecer el nuevo directorio de trabajo
WORKDIR /app50

# Descargar tu script
RUN curl -o websocket973.py https://raw.githubusercontent.com/nube50/SshWs8080/refs/heads/main/websocket973.py
RUN chmod +x websocket973.py

# Exponer solo el puerto del WebSocket (8080)
EXPOSE 8080

# Iniciar SSH en segundo plano y correr el script como principal
CMD /usr/sbin/sshd && python2 websocket973.py 8080
