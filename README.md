# Integrador1-Paladart

Proyecto Integrador 1 - Sistema de Ventas y Emisión de Comprobantes para Restaurante Paladart.

## Arquitectura

El proyecto sigue una arquitectura por capas:

- Presentation
- Business
- Persistence
- Domain

## Tecnologías utilizadas

- Java 21
- Maven
- Apache POI
- Logback
- Google Guava
- Git y GitHub

## Componentes implementados

### Domain
- Venta.java

### Persistence
- IVentaDAO.java
- VentaDAOMock.java

### Business
- VentaService.java

### Presentation
- Main.java

### Util
- ExportadorExcel.java

## Funcionalidades

- Registro de ventas
- Validaciones de negocio con Google Guava
- Registro de eventos mediante Logback
- Exportación de ventas a Excel usando Apache POI
- Arquitectura por capas
- Patrón DAO
- Inyección de dependencias
