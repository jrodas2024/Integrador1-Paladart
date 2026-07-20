package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Venta;

import java.util.List;

/*
 * Interfaz que define las operaciones disponibles
 * para almacenar y consultar ventas.
 *
 * La capa Business utiliza esta interfaz y no depende
 * directamente de una implementación específica.
 *
 * Sus implementaciones pueden ser:
 *
 * - VentaDAOMock: almacena datos temporalmente en memoria.
 * - VentaDAO: almacena datos realmente en PostgreSQL.
 */
public interface IVentaDAO {

    /*
     * Registra una venta y devuelve el identificador
     * generado automáticamente por PostgreSQL.
     */
    int crearVenta(Venta venta);

    /*
     * Busca una venta mediante su identificador.
     *
     * Devuelve la venta encontrada o null
     * cuando el registro no existe.
     */
    Venta buscarVenta(int id);

    /*
     * Actualiza los datos de una venta existente.
     */
    void actualizarVenta(Venta venta);

    /*
     * Devuelve todas las ventas registradas.
     *
     * Si no existen ventas, devuelve una lista vacía.
     */
    List<Venta> listarVentas();
}