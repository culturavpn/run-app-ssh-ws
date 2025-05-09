# Imagen base con Python 2.7
FROM python:2.7-slim

# Instalar OpenSSH y curl
RUN apt-get update && apt-get install -y openssh-server curl && rm -rf /var/lib/apt/lists/*

# Crear usuario 'docker' con contraseña 'docker123'
RUN useradd -m -s /bin/bash docker && echo 'docker:docker123' | chpasswd

# Habilitar autenticación por contraseña en SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Crear carpeta para SSH si no existe
RUN mkdir /var/run/sshd

# Directorio de trabajo y descarga del script
WORKDIR /app
RUN curl -o websocket973.py https://raw.githubusercontent.com/nube50/SshWs8080/refs/heads/main/websocket973.py

# Exponer solo el puerto 8080
EXPOSE 8080

# Iniciar SSH y ejecutar el script con Python 2
CMD /usr/sbin/sshd && python websocket973.py 8080
