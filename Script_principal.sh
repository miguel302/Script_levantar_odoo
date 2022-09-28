
#---------------lo q me ha costao---------------ROOT------------------------------------
sudo apt-get update -y && sudo apt-get upgrade -y # No lo pone angel, pero al intalar postgres me dio error E: Unable to locate package postgresql

# AXEL Instalar git, npm, postgresql, python3-dev:
sudo apt-get install git -y npm python3-dev postgresql 

#Instalar paquete para manejar entornos virtuales (env) en python3:
sudo apt-get install python3-venv -y

#Creando un enlace simbolico de nodejs a node:
sudo ln -s /usr/bin/nodejs /usr/bin/node  #INCIDENCIA YA EXISTE ln: failed to create symbolic link '/usr/bin/node': File exists
	

#Instalando el compilador de less
sudo npm install -g less@3.0.4 less-plugin-clean-css
              #NO ME DA ERROR ??? -->[DEPRECATED] FUNCIONA PERO ME DA ERRORES EN UBUNTU (Probado solo en v11)
              #DICE QUE: la solicitud ha quedado obsoleta

sudo npm install -g less less-plugin-clean-css

# hasta ahora tenemos root (desde donde estamos)    y  
#         postgres:x:113:118:PostgreSQL administrator,,,:/var/lib/postgresql:/bin/bash
#         que se instalo cd instalamos postgre 
#       TIP para ver los usuarios creados       cat /etc/passwd

#[SEGUNDA PARTE] Creacion de usuario del sistema operativo y en PostgreSQL
#Agregar un nuevo usuario y estableciendo su clave:
sudo adduser --system --home=/opt/odoo --group odoo
sudo passwd odoo     # ES NESARIO PONER CONTRASEÑA ?????
# OJO ME ESTE USUARIO            odoo:x:114:119::/opt/odoo:/usr/sbin/nologin
# OJO   nologin ??? por pone esto creo recordar que despues me daba error este error "This Account is currently not available"
''' SOLUCION (si es q esto es un problema)
           ejecutamos    sudo chsh -s /bin/bash odoo   
           y asi es como se queda la cosa       odoo:x:114:119::/opt/odoo:/bin/bash'''
sudo chsh -s /bin/bash odoo

#Crear usuario de la BBDD en postgresql:
#----------------------------POSTGRES------------------------------------------

#Crear usuario de la BBDD en postgresql:
sudo su - postgres
createuser --createdb --username postgres --no-createrole --no-superuser --pwprompt odoo
#Ingresar clave (recomiendo utilizar la misma que el nombre "odoo")


# 09-2022 ------------- ROOT  ----------AUNQUE NO PONE LOS COMANDO SUPONGO Q SE VA DE POSTGRES A ODOO-------------
#[TERCERA PARTE] Descargando, configurando e instalando odoo
#Establecer python3 por defecto en el sistema operativo:

          # Actualizamos las Alternativas de Python
          #       OOOOOOOOOOOJOOOOOOOOOOOOOOOOOOOO NO LO EJECUTA
       sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8.10 # (O        la      version que este en ese momento intalada)
          # ME PIDE CONTRASEL
        sudo update-alternatives --config python
          #       OOOOOOOOOOJOOOOOOOOOOOOO   ERRRROOOR  update-alternatives: error: no alternatives for python


#Ingresar con el usuario creado:
sudo su - odoo -s /bin/bash    # OJOOOO con su odoo no me dejara por la schell la crea como /bin/bash/nologin   verlo en cat/etc??????


mkdir V14  # RECODAR Q ESTAMOS EN /HOME/OPT
cd V14

#Crear un entorno virtual de python para odoo:
#En el directorio Home de odoo [/opt/odoo/]:

#python3 -m venv nombre_del_entorno # (virt, para este caso)
python3 -m venv virt

#Activar el entorno (deactivate para desactivar)
source virt/bin/activate

#Descargar el codigo fuente en la HOME de odoo o transferirlos a la ruta del servidor
#En este caso [/opt/odoo]:

git clone https://github.com/odoo/odoo --depth 1 --branch 14.0 --single-branch


python3 setup.py install 
#(En caso de error de dependencia, instalar manaulmente las faltan y ejecutar nuevamente, o llamar python desde la ruta del entorno virtual EJ: ../virt/bin/python setup.py install)

#(Opcional): volver a ejecutar:

pip3 install -r odoo/requirements.txt
#Correr o, en efecto, intentar correr odoo/odoo-bin:
#Seguramente de error de varias dependencias y modulos de python, asi que se deben instalar manualmente tantas veces ya esten todas.

#Lista de algunos que podrian faltar:


# Actualizar pip3
pip3 install --upgrade pip
#Instalar las dependencias de python para odoo:
pip3 install -r odoo/requirements.txt
# ESTOS SON LOS QUE DAN ERROR Y SUS SUSTITUTOS
         # sudo apt-get install python-psycopg2
sudo apt-get install libpq-dev
pip install psycopg2-binary
pip3 install psycopg2

# Posibles librerias faltantes:
pip3 install pypdf2
pip3 install passlib
pip3 install babel
pip3 install lxml
pip3 install decorator
pip3 install six
pip3 install pyaml
pip3 install python-dateutil
pip3 install image # (para PIL)
pip3 install Werkzeug==0.11.15
pip3 install psutil
pip3 install urllib3
pip3 install chardet
pip3 install certifi
pip3 install idna
pip3 install jinja2
pip3 install html2text
pip3 install docutils
pip3 install num2words
pip3 install phonenumbers
pip3 install requests
pip3 install reportlab
pip3 install suds-py3
easy_install vatnumber

# Instalar Wkhtmltopdf [PRIMERA OPCION]
sudo apt-get install libfontconfig1 libxrender1
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
mv wkhtmltox/bin/wkhtmlto* /usr/bin/
ln -nfs /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf
Instalar Wkhtmltopdf [SEGUNDA OPCION]
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
tar xvf wkhtmltox*.tar.xz
sudo mv wkhtmltox/bin/wkhtmlto* /usr/bin
sudo apt-get install -y openssl build-essential libssl-dev libxrender-dev git-core libx11-dev libxext-dev libfontconfig1-dev libfreetype6-dev fontconfig

----------------------------------------- ME HE QUEDADO POR AQUI

# Generar archivo de configuracion:
./odoo-bin -s

#Exportar archivo de ocnfiguracion a /etc:
# En caso de error, intentarlo con un usuario con privilegios
#            PTE DE HACER             
            cat .odoorc > /etc/odoo.conf
# Con usuario con privilegio

sudo bash -c "cat /opt/odoo/.odoorc > /etc/odoo.conf"

#Llamar a odoo.bin con el archvo de configuracion previamente creado
odoo/odoo-bin --config=/etc/odoo.conf

#Colocar el log de Odoo en la plataforma
sudo mkdir /var/log/odoo
sudo chown odoo /var/log/odoo

#Luego, colocar la siguiente linea en el archivo dentro de /etc/odoo.conf:

logfile = /var/log/odoo/odoo.log
#Crear un service de odoo
#Crear el siguiente archivo con usuario con privilegios:
sudo nano /lib/systemd/system/odoo.service


#Informacion del archivo:
#[Unit]
#Description=Odoo v14 de desarrollo por Kevin Rojas krojas.alfaro7@gmail.com

#[Service]
#Type=simple
#PermissionsStartOnly=true
#SyslogIdentifier=odoo     
#User=odoo
#Group=odoo
#ExecStart=/opt/odoo/virt/bin/python /opt/odoo/odoo/odoo-bin --config=/etc/odoo.conf
#WorkingDirectory=/opt/odoo/odoo

#[Install]
#WantedBy=multi-user.target


#Cambiar permisos del archivo:
sudo chmod 755 /lib/systemd/system/odoo.service 
# Cambiar protietario del archvivo a root (por segurordad)

sudo chown root: /lib/systemd/system/odoo.service
#Comandos utiles post instalacion
#Levantar y correr el servicio o daemon
#Levantar
sudo systemctl start odoo
#Ver status
sudo systemctl status odoo

#Reiniciar
sudo systemctl restart odoo
#Logs de odoo
#Ver
tail -f /var/log/odoo/odoo.log



#----------------------------ODOO------------------------------------------



#---------------------------VIRTUAL----------------------------------------
