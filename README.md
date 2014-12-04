This container will look at all other containers and proxy port 80 for any
containers that define a VIRTUAL_HOST environment variable.

The example below will server the first container under the domain example.com.

# Running the container to be proxied

    docker run -itd -e VIRTUAL_HOST=example.com ...

# Running the proxy

    docker run -itd -p 80:80 -v /var/run/docker.sock:/var/run/docker.sock --name nginx_proxy ihadgraft:nginx_proxy

