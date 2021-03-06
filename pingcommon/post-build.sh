#!/usr/bin/env sh
# it is necessary to make the message of the day writable for the user
# so that the motd facility can work with:
#   - inside-out permissions (when stepped down via gosu or any setuid for that matter)
#   - with outside-in security context
#       - when -u|--user is provided to docker
#       - when security context block is defined in k8s configmap
chmod go+w /etc/motd

# create the mounts
for dir in backup in logs out ; do
    mkdir /opt/${dir}
done

# Ubuntu-specific post-install
if type apt-get >/dev/null 2>/dev/null ; then
    ln -s /usr/lib/jvm/java-11-openjdk-amd64 /opt/java
fi

# Centos-specific post-install
if type yum >/dev/null 2>/dev/null ; then
    ln -s /etc/alternatives/java_sdk /opt/java
fi

# Alpine-specific post-install
if type apk >/dev/null 2>/dev/null ; then
    ln -s /usr/lib/jvm/default-jvm /opt/java
fi

chmod -R +rwx /opt/backup /opt/in /opt/logs /opt/out    

# give each file the same permission for others as for the user
chmod -R o=u /opt
rm -f ${0}