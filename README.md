# Integrador1-Paladart

Proyecto Integrador 1 - Sistema Web de Gestión de Ventas y Emisión de Comprobantes para el restaurante **Paladart**.

---

# Descripción

Paladart es una aplicación web desarrollada en Java que permite registrar ventas, consultar el listado de ventas y exportar la información a un archivo Excel. El proyecto fue desarrollado aplicando arquitectura por capas, patrón DAO, inyección de dependencias y pruebas unitarias.

---

# Arquitectura del Proyecto

El proyecto está organizado utilizando una arquitectura por capas:

## Presentation
- VentaServlet.java
- index.jsp
- ventas.jsp
- listarVentas.jsp

## Controller
- VentaController.java

## Business
- VentaService.java

## Persistence
- IVentaDAO.java
- VentaDAOMock.java

## Domain
- Venta.java

## Util
- ExportadorExcel.java

---

# Patrones y Principios Aplicados

## Arquitectura por Capas

Se separó la aplicación en las capas Presentation, Controller, Business, Persistence, Domain y Util para mejorar el mantenimiento, organización y escalabilidad.

## MVC (Model - View - Controller)

Se implementó el patrón MVC en la aplicación web:

- Model: Venta
- View: JSP (index.jsp, ventas.jsp y listarVentas.jsp)
- Controller: VentaServlet y VentaController

## DAO (Data Access Object)

Implementado mediante:

- IVentaDAO
- VentaDAOMock

Permite desacoplar la lógica de negocio del acceso a datos.

## Inyección de Dependencias

Las dependencias son inyectadas mediante el constructor.

Ejemplo:

```java
IVentaDAO dao = new VentaDAOMock();
VentaService service = new VentaService(dao);
```

## Principios SOLID

Se aplica el principio DIP (Dependency Inversion Principle), permitiendo cambiar fácilmente la implementación del acceso a datos sin modificar la lógica de negocio.

---

# Tecnologías y Librerías Utilizadas

- Java 21
- Maven
- Apache Tomcat 10.1
- JSP
- Jakarta Servlet
- Bootstrap 5
- SweetAlert2
- Apache POI
- Google Guava
- Logback
- JUnit 5
- Mockito
- Git y GitHub

---

# Funcionalidades Implementadas

- Registro de ventas.
- Listado de ventas.
- Exportación de ventas a Excel (.xlsx).
- Generación automática del ID de venta.
- Validaciones con Google Guava.
- Registro de eventos mediante Logback.
- Mensajes interactivos con SweetAlert2.
- Arquitectura por capas.
- Patrón DAO.
- Inyección de dependencias.
- Aplicación del patrón MVC.
- Aplicación del principio SOLID (DIP).
- Pruebas unitarias con JUnit 5 y Mockito.

---

# Flujo de la Aplicación

```
JSP
   │
   ▼
VentaServlet
   │
   ▼
VentaController
   │
   ▼
VentaService
   │
   ▼
IVentaDAO
   │
   ▼
VentaDAOMock
```

---

# Pruebas Unitarias

Las pruebas unitarias se implementaron en:

```
src/test/java/pe/utp/paladart/business/VentaServiceTest.java
```

## Casos de prueba

- Validar método de pago obligatorio.
- Validar total mayor a cero.
- Validar ID mayor a cero.
- Registrar venta correctamente utilizando Mockito.

## Resultado

- 4 pruebas ejecutadas.
- 0 errores.
- 0 fallos.

```
Tests run: 4
Failures: 0
Errors: 0
BUILD SUCCESS
```

---

# Ejecución del Proyecto

## Compilar

```bash
mvn clean package
```

## Desplegar

Desplegar el archivo generado:

```
target/paladart-1.0-SNAPSHOT.war
```

en Apache Tomcat 10.1.

## Acceder desde el navegador

```
http://localhost:8080/paladart-1.0-SNAPSHOT/
```

---

# Autor

Proyecto desarrollado para el curso **Integrador I - Sistemas de Software**.

Universidad Tecnológica del Perú (UTP).