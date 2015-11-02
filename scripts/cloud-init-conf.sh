if [ -n "${RSYNC}" ]; then
    /usr/bin/rsync -a --delete rsync://cobbler100/athena/prod rsync://cobbler100/athena/techops rsync://cobbler100/athena/scripts rsync://cobbler100/athena/intranet rsync://cobbler100/athena/athenax /usr/local/athena
fi

mkdir -p /etc/facter/facts.d
echo "athena_server_role=${ROLE}" > /etc/facter/facts.d/athena.txt
echo "build ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users

cat > /etc/cloud/cloud.cfg.d/03_puppet.cfg << EOM
puppet:
 conf:
   agent:
     server: "puppet10vip.athenahealth.com"
     certname: "%i.devcloud.athenahealth.com"
EOM

cat > /etc/cloud/cloud.cfg.d/09_copy_key.cfg << EOM
runcmd:
 - "cat ~cloud-user/.ssh/authorized_keys >> ~build/.ssh/authorized_keys"
EOM

echo '172.25.21.207 devhome' >> /etc/hosts
echo '172.25.21.208 fs22b' >> /etc/hosts

sync