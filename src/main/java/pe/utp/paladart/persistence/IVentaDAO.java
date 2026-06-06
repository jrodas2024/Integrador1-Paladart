package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Venta;

/* Interfaz que define las operaciones de acceso a datos para la entidad Venta.*/

public interface IVentaDAO {

    // Registrar una nueva venta
    void crearVenta(Venta venta);

    // Buscar una venta por su identificador
    Venta buscarVenta(int id);

    // Actualizar una venta existente
    void actualizarVenta(Venta venta);
}