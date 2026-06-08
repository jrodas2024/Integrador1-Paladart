# Integrador1-Paladart

Proyecto Integrador 1 - Sistema de Ventas y Emisión de Comprobantes para Restaurante Paladart.

## Arquitectura

El proyecto sigue una arquitectura por capas:

### Presentation Layer
- Main.java
- VentaView.java
- VentaController.java

### Business Layer
- VentaService.java

### Persistence Layer
- IVentaDAO.java
- VentaDAOMock.java

### Domain Layer
- Venta.java

## Patrones y Principios Aplicados

### Arquitectura por Capas

Se separó la aplicación en Presentation, Business, Persistence y Domain para facilitar el mantenimiento y escalabilidad.

### MVC (Model - View - Controller)

Implementado en la capa de presentación:

- Model: Venta
- View: VentaView
- Controller: VentaController

### DAO (Data Access Object)

Implementado mediante:

- IVentaDAO
- VentaDAOMock

Permite desacoplar la lógica de negocio del acceso a datos.

### Inyección de Dependencias

Las dependencias son inyectadas mediante interfaces.

Ejemplo:
IVentaDAO dao = new VentaDAOMock();
VentaService ventaService = new VentaService(dao);

### Principios SOLID

Se aplica el principio DIP, permitiendo que la lógica de negocio utilice la interfaz IVentaDAO y pueda cambiar fácilmente la implementación del acceso a datos sin modificar el servicio.

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


## Funcionalidades implementadas

* Registro de ventas.
* Validaciones de negocio con Google Guava.
* Registro de eventos mediante Logback.
* Exportación de ventas a Excel usando Apache POI.
* Arquitectura por capas.
* Patrón DAO.
* Inyección de dependencias.
* Pruebas unitarias con JUnit.
* Implementación de MVC.
* Aplicación del principio SOLID (DIP).

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