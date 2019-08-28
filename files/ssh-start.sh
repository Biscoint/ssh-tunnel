#!/bin/sh

if [ "$PROXY_MODE" = true ] ; then
  SSH_ARGS="-D $PORT_EXPOSED"
else
  SSH_ARGS="-L $PORT_EXPOSED:$ADDR_TO:$PORT_TO"
fi

sleep 3 && /usr/bin/ssh -v -oBatchMode=yes -Ng $SSH_ARGS -p $ADDR_TUNNEL_SSH_PORT $REMOTE_USER@$ADDR_TUNNEL
