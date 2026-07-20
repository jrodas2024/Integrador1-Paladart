package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Venta;

import java.util.ArrayList;
import java.util.List;

/*
 * Implementación simulada (Mock) del DAO de ventas.
 *
 * Esta clase no utiliza PostgreSQL.
 * En su lugar, almacena las ventas temporalmente
 * en una lista que permanece en memoria.
 *
 * Se utiliza principalmente para pruebas unitarias
 * y para validar la lógica de negocio sin depender
 * de una base de datos real.
 */
public class VentaDAOMock implements IVentaDAO {

    /*
     * Lista que simula una tabla de la base de datos.
     */
    private final List<Venta> ventas =
            new ArrayList<>();

    /*
     * Registra una venta en la lista simulada.
     *
     * Devuelve el ID de la venta, igual que hace
     * la implementación real con PostgreSQL.
     */
    @Override
    public int crearVenta(Venta venta) {

        /*
         * Agrega la venta a la lista en memoria.
         */
        ventas.add(venta);

        System.out.println(
                "Venta guardada correctamente."
        );

        /*
         * Devuelve el ID de la venta.
         *
         * En el Mock el ID ya viene dentro del objeto,
         * porque no existe una base de datos que lo genere.
         */
        return venta.getIdVenta();
    }

    /*
     * Busca una venta por su identificador.
     */
    @Override
    public Venta buscarVenta(int id) {

        for (Venta venta : ventas) {

            if (venta.getIdVenta() == id) {
                return venta;
            }
        }

        /*
         * Si no existe la venta,
         * devuelve null.
         */
        return null;
    }

    /*
     * Actualiza una venta existente.
     */
    @Override
    public void actualizarVenta(Venta venta) {

        for (int i = 0; i < ventas.size(); i++) {

            if (ventas.get(i).getIdVenta()
                    == venta.getIdVenta()) {

                ventas.set(i, venta);

                System.out.println(
                        "Venta actualizada."
                );

                return;
            }
        }
    }

    /*
     * Devuelve todas las ventas almacenadas
     * en memoria.
     */
    @Override
    public List<Venta> listarVentas() {

        return ventas;
    }
}