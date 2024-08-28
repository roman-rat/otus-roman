#!/bin/bash
cat << EOF > /usr/share/nginx/html/cgi-bin/test.cgi
#!/bin/bash
echo "Content-type: text/html"
echo
echo "<html><body><h1>OTUS OTUS</h1></body></html>"o
EOF