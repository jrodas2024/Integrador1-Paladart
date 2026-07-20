# Paladart

Sistema Web de Ventas y Emisión de Comprobantes desarrollado en Java como proyecto del curso Integrador I.

---

## Tecnologías utilizadas

- Java 21
- JSP y Servlets
- Apache Tomcat 10
- PostgreSQL 17
- Maven
- Docker y Docker Compose
- Apache POI
- Google Guava
- Logback

---

## Arquitectura

El proyecto utiliza una arquitectura por capas:

Presentation → Controller → Business → Persistence (DAO) → PostgreSQL

---

## Requisitos

Antes de ejecutar el proyecto es necesario tener instalado:

- Docker Desktop
- Docker Compose

---

## Configuración

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
```

### 2. Ingresar al proyecto

```bash
cd Integrador1-Paladart
```

### 3. Crear el archivo `.env`

Copiar el archivo:

```
.env.example
```

como:

```
.env
```

Modificar las credenciales según el entorno de trabajo.

---

## Ejecutar el proyecto

Construir e iniciar los contenedores:

```bash
docker compose up --build -d
```

Verificar que los contenedores estén en ejecución:

```bash
docker ps
```

Abrir la aplicación en el navegador:

```
http://localhost:8080/paladart
```

---

## Detener el proyecto

Detener los contenedores:

```bash
docker compose down
```

---

## Base de datos

PostgreSQL utiliza un volumen Docker (`paladart_data`) para almacenar la información.

Al detener o eliminar los contenedores con:

```bash
docker compose down
```

los datos de la base de datos se conservan.

Solo se eliminarán si también se elimina el volumen:

```bash
docker compose down -v
```

---



## Variables de entorno

Las credenciales de conexión se administran mediante variables de entorno.

El archivo `.env` contiene la configuración utilizada por Docker y por la aplicación Java durante la ejecución.

El archivo `.env` no se incluye en el repositorio gracias al `.gitignore`. Para facilitar la configuración del proyecto se proporciona el archivo `.env.example`.

---

---

## Comandos útiles

Construir nuevamente la aplicación:

```bash
docker compose up --build -d
```

Iniciar los contenedores existentes:

```bash
docker compose up -d
```

Detener los contenedores:

```bash
docker compose down
```

Eliminar contenedores y la base de datos:

```bash
docker compose down -v
```

## Autor

**Julio Rodas**

Universidad Tecnológica del Perú

Curso: Integrador I