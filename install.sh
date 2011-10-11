cp /var/mtlfe/dispatch/config/upstart/mtlfe-server-8001.conf /etc/init/mtlfe-server-8001.conf
cp /var/mtlfe/dispatch/config/upstart/mtlfe-server-8002.conf /etc/init/mtlfe-server-8002.conf
cp /var/mtlfe/dispatch/config/upstart/mtlfe-server-8003.conf /etc/init/mtlfe-server-8003.conf
cp /var/mtlfe/dispatch/config/upstart/mtlfe-hook-9001.conf   /etc/init/mtlfe-hook-9001.conf

cp /var/mtlfe/dispatch/config/monit/monitrc /etc/monit/monitrc
cp /var/mtlfe/dispatch/config/nginx/mtlfe.org /etc/nginx/sites-available/mtlfe.org

rm -rf /etc/nginx/sites-enabled/mtlfe.org
ln -s /etc/nginx/sites-available/mtlfe.org /etc/nginx/sites-enabled/mtlfe.org 

start mtlfe-server-8001.conf
start mtlfe-server-8002.conf
start mtlfe-server-8003.conf
start mtlfe-server-9001.conf

# /etc/init.d/nginx restart &&\
# start mtlfe &&\
# monit -d 60 -c /etc/monit/monitrc &&\

