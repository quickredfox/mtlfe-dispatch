/etc/init.d/nginx stop && killall monit

stop mtlfe-server-8001 
stop mtlfe-server-8002 
stop mtlfe-server-8003 
stop mtlfe-hook-9001

rm /etc/init/mtlfe-server-8001.conf 
rm /etc/init/mtlfe-server-8002.conf 
rm /etc/init/mtlfe-server-8003.conf 
rm /etc/init/mtlfe-hook-9001.conf   

rm /etc/monit/monitrc
rm  /etc/nginx/sites-available/mtlfe.org

rm -rf /etc/nginx/sites-enabled/mtlfe.org

