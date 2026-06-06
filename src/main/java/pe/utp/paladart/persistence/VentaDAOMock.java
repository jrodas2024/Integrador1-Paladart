package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Venta;

/*
 * Implementación temporal (Mock)
 * que simula el acceso a datos.
 */
public class VentaDAOMock implements IVentaDAO {

    @Override
    public void crearVenta(Venta venta) {

        // Simula el guardado de una venta
        System.out.println("Venta guardada correctamente.");
    }

    @Override
    public Venta buscarVenta(int id) {

        // Simula la búsqueda de una venta
        System.out.println("Buscando venta ID: " + id);

        return null;
    }

    @Override
    public void actualizarVenta(Venta venta) {

        // Simula la actualización de una venta
        System.out.println("Venta actualizada.");
    }
}