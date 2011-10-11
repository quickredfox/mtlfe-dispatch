cp /var/mtlfe/dispatch/config/upstart/mtlfe.conf /etc/init/mtlfe.conf &&
cp /var/mtlfe/dispatch/config/monit/monitrc /etc/monit/monitrc &&\
cp /var/mtlfe/dispatch/config/nginx/mtlfe.org /etc/nginx/sites-available/mtlfe.org &&\
ln -s /etc/nginx/sites-available/mtlfe.org /etc/nginx/sites-enabled/mtlfe.org &&\
# start mtlfe
# /etc/init.d/nginx restart &&\
# start mtlfe &&\
# monit -d 60 -c /etc/monit/monitrc &&\

