if [ -n "${RSYNC}" ]; then
    /usr/bin/rsync -a --delete rsync://cobbler100/athena/prod rsync://cobbler100/athena/techops rsync://cobbler100/athena/scripts rsync://cobbler100/athena/intranet rsync://cobbler100/athena/athenax /usr/local/athena
fi

mkdir -p /etc/athena/athenax
echo development > /etc/athena/athenax/environment

mkdir -p /etc/facter/facts.d
echo "athena_server_role=${ROLE}" > /etc/facter/facts.d/athena.txt
echo "build ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users

cat > /etc/cloud/cloud.cfg.d/01_timezone.cfg << EOM
timezone: America/New_York
EOM

cat > /etc/cloud/cloud.cfg.d/03_puppet.cfg << EOM
puppet:
 conf:
   agent:
     server: "puppet10vip.athenahealth.com"
     certname: "%i.devcloud.athenahealth.com"
EOM

cat > /etc/cloud/cloud.cfg.d/10_devcloud_setup.cfg << EOM
runcmd:
 - "cat ~cloud-user/.ssh/authorized_keys >> ~build/.ssh/authorized_keys"
 - "mkdir -p /etc/athena/athenax"
 - "echo development > /etc/athena/athenax/environment"
 - "/usr/bin/rsync -a --delete rsync://cobbler100.athenahealth.com/athena/prod rsync://cobbler100.athenahealth.com/athena/techops rsync://cobbler100.athenahealth.com/athena/scripts rsync://cobbler100.athenahealth.com/athena/intranet rsync://cobbler100.athenahealth.com/athena/athenax /usr/local/athena"
EOM

echo '172.28.21.202 fshome100a' >> /etc/hosts

sync