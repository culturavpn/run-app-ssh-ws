# Imagen base oficial de Python 3.11
FROM python:3.11-slim

# Instalar OpenSSH y curl
RUN apt-get update && apt-get install -y openssh-server curl && rm -rf /var/lib/apt/lists/*

# Crear usuario 'docker' con contraseña 'docker123'
RUN useradd -m -s /bin/bash docker && echo 'thomas:culturavpn' | chpasswd

# Habilitar autenticación por contraseña en SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Configurar directorio de trabajo y descargar script WebSocket
WORKDIR /app
RUN curl -o websocket973.py https://raw.githubusercontent.com/nube50/SshWs8080/refs/heads/main/websocket973.py

# Exponer solo el puerto 8080 (no se expone el 22)
EXPOSE 8080

# Iniciar el servidor SSH y ejecutar el script WebSocket
CMD ["/bin/bash", "-c", "/usr/sbin/sshd && exec python3 websocket973.py 8080"]
