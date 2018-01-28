if [ -n "$SSH_AUTH_SOCK" ] ; then
    echo "Killing agent"
    eval `/usr/bin/ssh-agent -k`
fi
