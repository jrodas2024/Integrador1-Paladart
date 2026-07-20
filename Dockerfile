# =========================================================
# ETAPA 1: COMPILACIÓN DEL PROYECTO CON MAVEN
# =========================================================

FROM maven:3.9-eclipse-temurin-21 AS build

# Carpeta de trabajo dentro del contenedor
WORKDIR /app

# Copia primero el archivo de configuración de Maven
COPY pom.xml .

# Descarga previamente las dependencias
RUN mvn dependency:go-offline -B

# Copia el código fuente del proyecto
COPY src ./src

# Compila el proyecto y genera target/paladart.war
RUN mvn clean package -DskipTests


# =========================================================
# ETAPA 2: EJECUCIÓN DE LA APLICACIÓN EN TOMCAT
# =========================================================

FROM tomcat:10.1-jdk21-temurin

# Elimina las aplicaciones predeterminadas de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copia el WAR generado en la etapa anterior
COPY --from=build /app/target/paladart.war \
    /usr/local/tomcat/webapps/ROOT.war

# Puerto utilizado por Tomcat
EXPOSE 8080

# Inicia Tomcat en primer plano
CMD ["catalina.sh", "run"]