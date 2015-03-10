mkdir -p /etc/facter/facts.d
echo athena_server_role=devcloud > /etc/facter/facts.d/athena.txt

cat > /etc/cloud/cloud.cfg.d/03_puppet.cfg << EOM
puppet:
 conf:
   agent:
     server: "puppet10vip.athenahealth.com"
     certname: "%i.devcloud.athenahealth.com"
EOM

sync