#!/bin/bash

# 1. Actualizar repositorios, instalar Nginx, instalar git para traer el repositorio
apt update
apt install -y nginx git vsftpd

# Verificar que Nginx esté funcionando
sudo systemctl status nginx

# 2. Crear la carpeta del sitio web
sudo mkdir -p /var/www/prueba/html

# Clonar el repositorio de ejemplo en la carpeta del sitio web
git clone https://github.com/cloudacademy/static-website-example /var/www/prueba/html

# Asignar permisos adecuados
sudo chown -R www-data:www-data /var/www/prueba/html
sudo chmod -R 755 /var/www/prueba

# 3. Configurar Nginx para servir el sitio web
# Crear archivo de configuración del sitio en sites-available
sudo bash -c 'cat > /etc/nginx/sites-available/prueba <<EOF
server {
    listen 80;
    listen [::]:80;
    root /var/www/prueba/html;
    index index.html index.htm index.nginx-debian.html;
    server_name www.fjmm.test;
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF'

# Crear enlace simbólico en sites-enabled
sudo ln -s /etc/nginx/sites-available/prueba /etc/nginx/sites-enabled/

# 4. Asegurarse de cambiar el archivo vsftpd.conf
# Se asume que este archivo se cambiará según tus necesidades

# 5. Crear el usuario 'fjmm'
sudo adduser fjmm
echo "fjmm:fjmm" | sudo chpasswd

# Crear la carpeta FTP para el usuario
sudo mkdir /home/fjmm/ftp

# Permisos para la carpeta
sudo chown vagrant:vagrant /home/fjmm/ftp
sudo chmod 755 /home/fjmm/ftp

# Crear los certificados de seguridad para vsftpd
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt

# Agregar el usuario 'fjmm' al grupo 'www-data'
sudo usermod -aG www-data fjmm

# 6. Crear la nueva carpeta para la página web 'extreme'
sudo mkdir -p /var/www/extreme

# Asignar permisos para la nueva carpeta
sudo chown www-data:www-data /var/www/extreme
sudo chmod 775 /var/www/extreme

# Crear archivo de configuración para 'extreme'
sudo bash -c 'cat > /etc/nginx/sites-available/extreme <<EOF
server {
    listen 80;
    listen [::]:80;
    root /var/www/extreme;
    index index.html index.htm index.nginx-debian.html;
    server_name www.extreme.test;
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF'

# Crear enlace simbólico en sites-enabled
sudo ln -s /etc/nginx/sites-available/extreme /etc/nginx/sites-enabled/

# Reiniciar Nginx para aplicar los cambios
sudo systemctl restart nginx

# Verificar el estado de Nginx para asegurar que todo esté funcionando
sudo systemctl status nginx
