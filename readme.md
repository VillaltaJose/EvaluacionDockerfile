# Evaluación
**Nombre:** José Villalta <br>
**Carrera:** Computación <br>
**Asignatura:** Sistemas Distribuidos <br>

## Instalación de la imagen
1. Nos descargamos la imagen desde docker hub:
```bash
docker pull villaltajose/evaluacion
```
2. Levantamos el contenedor con el siguiente comando:
```bash
docker run -d -p ${PORT}:80 -v ${PATH}:/app/front --name ${CONTAINER_NAME} villaltajose/evaluacion
```
Donde:
- **`${PORT}`:** es el puerto en donde deseamos levantar nuestra aplicación. En caso de no colocarlo se levantará en el puerto `80`.
- **`${PATH}`:** ruta donde tenemos nuestro frontend en `Angular`.
- **`${CONTAINER_NAME}`:** nombre de nuestro contenedor.

> **Nota:** en caso de realizar modificaciones en el frontend, es necesario reiniciar el contenedor. Para ello usamos el comando: `docker restart ${CONTAINER_NAME}`

## Dockerfile
Este proyecto utiliza la última imagen disponible de [ubuntu](https://hub.docker.com/_/ubuntu) en docker hub.

### Funcionamiento
1. Partimos de la imagen de ubuntu
```Dockerfile
FROM ubuntu:latest
```
2. Dentro de la imagen actualizamos los paquetes de ubuntu y realizamos la instalación de los paquetes `curl` y `gnupg` para poder realizar la instalación de `NodeJS` en los pasos siguientes.
```Dockerfile
RUN apt-get update
RUN apt-get install -y curl gnupg
```
3. Descargamos `NodeJS` en su versión `22.x` y procedemos a instalarlo mediante `bash`
```Dockerfile
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash -
RUN apt-get -y install nodejs
```
4. Realizamos la instalación de `nginx` con el manejador de paquetes de ubuntu
```Dockerfile
RUN apt-get install -y nginx
```
5. Instalamos el CLI de `Angular` mediante `npm`
```Dockerfile
RUN npm install -g @angular/cli
```
6. Cargamos la configuración de `nginx` para servir nuestra aplicación de `Angular`. Esta configuración la copiamos desde el repositorio y la colocamos en la carpeta de configuración de `nginx`. Además, eliminamos el sitio por defecto que se genera al instalar `nginx`.
```Dockerfile
COPY nginx.conf /etc/nginx/sites-available/default
RUN rm -rf /var/www/html/*
```
7. Creamos el volumen para nuestro front en la ruta `/app/front` y nos ubicamos en esa ruta.
```Dockerfile
VOLUME /app/front
WORKDIR /app/front
```
8. Ejecutamos los comandos para instalar las dependencias de nuestro proyecto, compilar y copiar los archivos generados a la carpeta de `nginx`. Finalmente, levantamos `nginx` en modo silencioso y servimos nuestra aplicación.
```Dockerfile
CMD ["bash", "-c", "npm install --force && ng build && cp -r /app/front/dist/front/* /var/www/html && nginx -g 'daemon off;'"]
EXPOSE 80
```

### Creación de imagen
Para construir nuestra imagen basándonos en el `Dockerfile` nos situamos en la raíz del repositorio y ejecutamos el siguiente comando:
```bash
docker build -t ups/evaluacion .
```
> Nota: reemplazamos `ups/evaluacion` por el nombre que queramos darle a nuestra imagen.