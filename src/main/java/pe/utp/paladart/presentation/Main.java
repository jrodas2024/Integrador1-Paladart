package pe.utp.paladart.presentation;

import com.google.common.collect.Lists;
import pe.utp.paladart.business.VentaService;
import pe.utp.paladart.controller.VentaController;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.IVentaDAO;
import pe.utp.paladart.persistence.VentaDAOMock;
import pe.utp.paladart.util.ExportadorExcel;
import pe.utp.paladart.view.VentaView;

import java.util.List;

/*
 * Clase principal del sistema.
 * Simula el registro de ventas utilizando
 * arquitectura por capas y patrón MVC.
 */
public class Main {

    public static void main(String[] args) {

        // Crear la implementación de persistencia
        IVentaDAO dao = new VentaDAOMock();

        // Inyectar la dependencia mediante el constructor
        VentaService ventaService = new VentaService(dao);

        // Crear la vista
        VentaView ventaView = new VentaView();

        // Crear el controlador
        VentaController ventaController =
                new VentaController(ventaService, ventaView);

        // Crear una lista de ventas utilizando Google Guava
        List<Venta> ventas = Lists.newArrayList(
                new Venta(1, 80.24, "Efectivo"),
                new Venta(2, 150.00, "Tarjeta"),
                new Venta(3, 45.50, "Yape"),
                new Venta(4, 200.00, "Plin")
        );

        // Registrar cada venta mediante el controlador
        for (Venta venta : ventas) {
            ventaController.registrarVenta(venta);
        }

        // Generar reporte Excel de ventas
        ExportadorExcel exportador = new ExportadorExcel();
        exportador.generarReporte(ventas);
    }
}