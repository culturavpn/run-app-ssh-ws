FROM rastasheep/ubuntu-sshd:18.04

# Instala Python 2, pip y curl
RUN apt-get update && \
    apt-get install -y python python-pip curl && \
    rm -rf /var/lib/apt/lists/*

# Crea el usuario 'docker' con contraseña 'docker123'
RUN useradd -m docker && echo "docker:docker123" | chpasswd

# Asegura autenticación por contraseña en SSH
RUN sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Directorio de trabajo
WORKDIR /app

# Descarga el script desde GitHub
RUN curl -o websocket973.py https://raw.githubusercontent.com/nube50/SshWs8080/refs/heads/main/websocket973.py

# Instala dependencias si son compatibles con Python 2 (ajusta si es necesario)
RUN pip install paramiko

# Expone solo el puerto 8080
EXPOSE 8080

# Comando para iniciar SSH internamente y ejecutar el script
CMD service ssh start && python websocket973.py 8080
