package pe.utp.paladart.business;

import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.IVentaDAO;

/*
 * Clase que contiene las reglas de negocio
 * relacionadas con las ventas.
 */
public class VentaService {

    private IVentaDAO ventaDAO;

    /*
     * Inyección de dependencias por constructor.
     */
    public VentaService(IVentaDAO ventaDAO) {
        this.ventaDAO = ventaDAO;
    }

    public void registrarVenta(Venta venta) {

        // Validar que el total sea mayor a cero
        if (venta.getTotal() <= 0) {
            System.out.println("Error: el total debe ser mayor a cero.");
            return;
        }

        // Delegar el guardado a la capa de persistencia
        ventaDAO.crearVenta(venta);
    }
}