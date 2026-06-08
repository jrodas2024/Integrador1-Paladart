# Integrador1-Paladart

Proyecto Integrador 1 - Sistema de Ventas y Emisión de Comprobantes para Restaurante Paladart.

## Arquitectura

El proyecto sigue una arquitectura por capas:

* Presentation
* Business
* Persistence
* Domain

## Tecnologías y librerías utilizadas

### Java 21

Lenguaje principal utilizado para el desarrollo del sistema.

### Maven

Gestión de dependencias y construcción del proyecto.

### Apache POI

Generación de reportes Excel (.xlsx) con formato y datos de ventas.

### Logback

Registro de eventos del sistema mediante logs.

### Google Guava

Validaciones y utilidades mediante:

* Preconditions.checkNotNull()
* Preconditions.checkArgument()
* Lists.newArrayList()

### JUnit 5

Implementación de pruebas unitarias para validar reglas de negocio.

### Git y GitHub

Control de versiones y gestión del repositorio.

## Componentes implementados

### Domain

* Venta.java

### Persistence

* IVentaDAO.java
* VentaDAOMock.java

### Business

* VentaService.java

### Presentation

* Main.java

### Util

* ExportadorExcel.java

## Funcionalidades implementadas

* Registro de ventas.
* Validaciones de negocio con Google Guava.
* Registro de eventos mediante Logback.
* Exportación de ventas a Excel usando Apache POI.
* Arquitectura por capas.
* Patrón DAO.
* Inyección de dependencias.
* Pruebas unitarias con JUnit.

## Pruebas Unitarias

Se implementaron pruebas unitarias en la clase:

src/test/java/pe/utp/paladart/business/VentaServiceTest.java

### Casos de prueba implementados

* validarMetodoPagoObligatorio()
* validarTotalMayorACero()
* validarIdVentaMayorACero()

### Resultado

* 3 pruebas ejecutadas correctamente.
* Todas las validaciones de negocio superadas satisfactoriamente.