# Integrador1-Paladart

Proyecto Integrador 1 - Sistema de Ventas y Emisión de Comprobantes para Restaurante Paladart.

## Arquitectura

- Presentation
- Business
- Persistence
- Domain

## Entidad implementada

- Venta

## Componentes

- Venta.java
- IVentaDAO.java
- VentaDAOMock.java
- VentaService.java
- Main.java
- 
## Patrón aplicado

Se implementó el patrón DAO (Data Access Object) mediante la interfaz IVentaDAO para desacoplar la lógica de negocio de la capa de persistencia.

## Inyección de dependencias

La clase VentaService recibe la interfaz IVentaDAO mediante su constructor, permitiendo cambiar la implementación de persistencia sin afectar la lógica de negocio.
