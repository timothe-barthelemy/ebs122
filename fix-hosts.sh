!/bin/sh
ip="$(hostname -I | awk '{ print $1 }')"
cat > /etc/hosts <<EOF
127.0.0.1 localhost
$ip       apps apps.example.com
EOF
exec "$@"
