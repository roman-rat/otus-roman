    #!/bin/bash
    sed -i '/^[^#]*include \/etc\/nginx\/default.d\/\*.conf;/a \
    location /cgi-bin/ {\n\
        fastcgi_pass unix:/run/fcgiwrap.socket;\n\
        include fastcgi_params;\n\
        fastcgi_param SCRIPT_FILENAME /usr/share/nginx/html$fastcgi_script_name;\n\
        fastcgi_param QUERY_STRING $query_string;\n\
        fastcgi_param REQUEST_METHOD $request_method;\n\
        fastcgi_param CONTENT_TYPE $content_type;\n\
        fastcgi_param CONTENT_LENGTH $content_length;\n\
    }' /etc/nginx/nginx-instance1.conf

    sed -i '/^[^#]*include \/etc\/nginx\/default.d\/\*.conf;/a \
    location /cgi-bin/ {\n\
        fastcgi_pass unix:/run/fcgiwrap.socket;\n\
        include fastcgi_params;\n\
        fastcgi_param SCRIPT_FILENAME /usr/share/nginx/html$fastcgi_script_name;\n\
        fastcgi_param QUERY_STRING $query_string;\n\
        fastcgi_param REQUEST_METHOD $request_method;\n\
        fastcgi_param CONTENT_TYPE $content_type;\n\
        fastcgi_param CONTENT_LENGTH $content_length;\n\
    }' /etc/nginx/nginx-instance2.conf