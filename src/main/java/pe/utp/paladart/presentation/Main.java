package pe.utp.paladart.presentation;

import pe.utp.paladart.business.VentaService;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.IVentaDAO;
import pe.utp.paladart.persistence.VentaDAOMock;

/*
 * Clase principal del sistema.
 * Simula el registro de una venta utilizando
 * la arquitectura por capas.
 */
public class Main {

    public static void main(String[] args) {

        // Crear la implementación de persistencia
        IVentaDAO dao = new VentaDAOMock();

        // Inyectar la dependencia mediante el constructor
        VentaService ventaService = new VentaService(dao);

        // Crear una venta de ejemplo
        Venta venta = new Venta(
                1,
                80.24,
                "Efectivo"
        );

        // Registrar la venta
        ventaService.registrarVenta(venta);
    }
}