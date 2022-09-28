#!/bin/bash
# You must to have at least > 2GB of RAM
# Ubuntu 18.04, 19, 20.04 LTS tested
# v2.3
# Last updated: 2020-05-19

#JC OS_NAME=$(lsb_release -cs)
#JC usuario=$USER
#JC DIR_PATH=$(pwd)
#JC VCODE=14
#JC VERSION=14.0
#JC PORT=1469
#JC DEPTH=1
#JC PROJECT_NAME=mitienda
#JC PATHBASE=/opt/$PROJECT_NAME
#JC PATH_LOG=$PATHBASE/log
#JC PATHREPOS=$PATHBASE/$VERSION/extra-addons
#JC PATHREPOS_OCA=$PATHREPOS/oca

#JC if [[ $OS_NAME == "disco" ]];

#JC then
#JC #JC 	echo $OS_NAME
#JC 	OS_NAME="bionic"

#JC fi

#JC if [[ $OS_NAME == "focal" ]];

#JC then
#JC 	echo $OS_NAME
#JC 	OS_NAME="bionic"

#JC fi

# ANGEL -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#ir a la documentacion y ahi te va diciendo q hacer a la secion fuente https://www.odoo.com/documentation/15.0/administration/install/install.html#source-install

sudo apt-get update -y && sudo apt-get upgrade -y # No lo pone angel, pero al intalar postgres me dio error E: Unable to locate package postgresql

adduser odoo   # nos pide contraseña y hay q metersela adduser es mas completo useradd
usermod -aG sudo odoo #PARA METER EN USUARIO EN GRUPO SUDO PARA Q TENGO PERMISO DE ADMINISTRADOR

apt install git # hay que hacerlo con root




su odoo
cd #para irse al home
mkdir ~/work15 # LIBRO
cd ~/work15 # LIBRO
# git clone https://github.com/odoo/odoo.git -b 15.0 \ --depth=1  # LIBRO
git clone https://github.com/Odoo/odoo.git --depth 1 --branch 15.0 --single-branch # ANGEL

sudo apt install python3.8-venv -y  # NO VIENE EN EL LIBRO PERO LA CONSOLA ME LO PIDE
python3 -m venv ~/work15/env15 #crear un nuevo entorno virtual LIBRO
source ~/work15/env15/bin/activate  #activando el entorno virtual LIBRO
pip install -U pip # Update pip    LIBRO
pip install -r ~/work15/odoo/requirements.txt #LIBRO OJO AQUI ME DAN ERRORES

''' EJEMPLO DEL ERROR Preparing metadata (setup.py) ... error
  error: subprocess-exited-with-error
  
  × python setup.py egg_info did not run successfully.
  │ exit code: 1
  ╰─> [23 lines of output]
      running egg_info
      creating /tmp/pip-pip-egg-info-tcf1z8lu/psycopg2.egg-info
      writing /tmp/pip-pip-egg-info-tcf1z8lu/psycopg2.egg-info/PKG-INFO
      writing dependency_links to /tmp/pip-pip-egg-info-tcf1z8lu/psycopg2.egg-info/dependency_links.txt
      writing top-level names to /tmp/pip-pip-egg-info-tcf1z8lu/psycopg2.egg-info/top_level.txt
      writing manifest file '/tmp/pip-pip-egg-info-tcf1z8lu/psycopg2.egg-info/SOURCES.txt'
      
      Error: pg_config executable not found.
      
      pg_config is required to build psycopg2 from source.  Please add the directory
      containing pg_config to the $PATH or specify the full executable path with the
      option:
      
          python setup.py build_ext --pg-config /path/to/pg_config build ...
      
      or with the pg_config option in 'setup.cfg'.
      
      If you prefer to avoid building psycopg2 from source, please install the PyPI
      'psycopg2-binary' package instead.
      
      For further information please check the 'doc/src/install.rst' file (also at
      <https://www.psycopg.org/docs/install.html>).
      
      [end of output]
  
  note: This error originates from a subprocess, and is likely not a problem with pip.
error: metadata-generation-failed

× Encountered error while generating package metadata.
╰─> See above for output.'''

pip install -e ~/work15/odoo  # instalar Odoo. Puede usar pip para esto
exit

# apt install python3 ANGEL de da q ya lo tengo instalado
apt-get install postgresql postgresql-client -y
su postgres
createuser --createdb --pwprompt odoo  #para crear la contraseña AQUI no lo hace como en la documentacion de ODOO

                                                     #$ sudo -u postgres createuser -s $USER
                                                     #$ createdb $USER

exit #para irnos nuevamente a root
apt install python3-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
    libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev \
    liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev
apt install python3-pip -y
cd /home/odoo/odoo/
pip3 install -r requirements.txt
cd
su odoo
cd
/home/odoo/odoo/odoo-bin #ejecutamos odoo
#ponemos en navegador ip:8069 y se nos tiene abrir odoo





#wk64="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1."$OS_NAME"_amd64.deb"
#wk32="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1."$OS_NAME"_i386.deb"

#sudo apt-get update && sudo apt-get upgrade



#sudo apt-get install -y libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev \
#libldap2-dev libssl-dev python-dev python3-dev build-essential libffi-dev \
#zlib1g-dev gcc


	#----- JUAN CARLOS-------
#sudo adduser --system --quiet --shell=/bin/bash --home=$PATHBASE --gecos 'ODOO' --group $usuario
#sudo adduser $usuario sudo

           # add universe repository & update (Fix error download libraries)
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y git
            # Update and install Postgresql
sudo apt-get install postgresql -y
sudo su - postgres -c "createuser -s $usuario"

sudo mkdir $PATHBASE
sudo mkdir $PATHBASE/$VERSION
sudo mkdir $PATHREPOS
sudo mkdir $PATHREPOS_OCA
sudo mkdir $PATH_LOG
cd $PATHBASE
        # Download Odoo from git source
sudo git clone https://github.com/odoo/odoo.git -b $VERSION --depth $DEPTH $PATHBASE/$VERSION/odoo
sudo git clone https://github.com/odooerpdevelopers/backend_theme.git -b $VERSION --depth $DEPTH $PATHREPOS/backend_theme
# ATENCION temporalmente dejamos la 13.0 dado que aun no existe el repo para v14, de este solo necesitamos el modulo web_responsive para
# instalar el modulo del backend_theme_v13
sudo git clone https://github.com/oca/web.git -b 14.0 --depth $DEPTH $PATHREPOS_OCA/web


# Install python3 and dependencies for Odoo
sudo apt-get -y install gcc python3-dev libxml2-dev libxslt1-dev \
 libevent-dev libsasl2-dev libldap2-dev libpq-dev \
 libpng-dev libjpeg-dev xfonts-base xfonts-75dpi

sudo apt-get -y install python3 python3-pip python3-setuptools htop
sudo pip3 install virtualenv

# FIX wkhtml* dependencie Ubuntu Server 18.04
sudo apt-get -y install libxrender1

# Install nodejs and less
sudo apt-get install -y npm node-less
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g less

# Download & install WKHTMLTOPDF
sudo rm $PATHBASE/wkhtmltox*.deb

if [[ "`getconf LONG_BIT`" == "32" ]];

then
	sudo wget $wk32
else
	sudo wget $wk64
fi

sudo dpkg -i --force-depends wkhtmltox_0.12.5-1*.deb
sudo apt-get -f -y install
sudo ln -s /usr/local/bin/wkhtml* /usr/bin
sudo rm $PATHBASE/wkhtmltox*.deb
sudo apt-get -f -y install

# install python requirements file (Odoo)
sudo rm -rf $PATHBASE/$VERSION/venv
sudo mkdir $PATHBASE/$VERSION/venv
sudo chown -R $usuario: $PATHBASE/$VERSION/venv
virtualenv -q -p python3 $PATHBASE/$VERSION/venv
sed -i '/libsass/d' $PATHBASE/$VERSION/odoo/requirements.txt
$PATHBASE/$VERSION/venv/bin/pip3 install libsass vobject qrcode num2words
$PATHBASE/$VERSION/venv/bin/pip3 install -r $PATHBASE/$VERSION/odoo/requirements.txt

cd $DIR_PATH

sudo mkdir $PATHBASE/config
sudo rm $PATHBASE/config/odoo$VCODE.conf
sudo touch $PATHBASE/config/odoo$VCODE.conf
echo "
[options]
; This is the password that allows database operations:
;admin_passwd =
db_host = False
db_port = False
;db_user =
;db_password =
data_dir = $PATHBASE/data
logfile= $PATH_LOG/odoo$VCODE-server.log

############# addons path ######################################

addons_path =
    $PATHREPOS,
    $PATHREPOS/backend_theme,
    $PATHREPOS_OCA/web,
    $PATHBASE/$VERSION/odoo/addons

#################################################################

xmlrpc_port = $PORT
;dbfilter = odoo$VCODE
logrotate = True
limit_time_real = 6000
limit_time_cpu = 6000
" | sudo tee --append $PATHBASE/config/odoo$VCODE.conf

sudo rm /etc/systemd/system/odoo$VCODE.service
sudo touch /etc/systemd/system/odoo$VCODE.service
sudo chmod +x /etc/systemd/system/odoo$VCODE.service
echo "
[Unit]
Description=Odoo$VCODE
After=postgresql.service

[Service]
Type=simple
User=$usuario
ExecStart=$PATHBASE/$VERSION/venv/bin/python $PATHBASE/$VERSION/odoo/odoo-bin --config $PATHBASE/config/odoo$VCODE.conf

[Install]
WantedBy=multi-user.target
" | sudo tee --append /etc/systemd/system/odoo$VCODE.service
sudo systemctl daemon-reload
sudo systemctl enable odoo$VCODE.service
sudo systemctl start odoo$VCODE

sudo chown -R $usuario: $PATHBASE

echo "Odoo $VERSION Installation has finished!! ;) by odooerpcloud.com"
IP=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7)
echo "You can access from: http://$IP:$PORT  or http://localhost:$PORT"

sudo reboot

