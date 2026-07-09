package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Venta;

import java.util.ArrayList;
import java.util.List;

/*
 * Implementación temporal (Mock)
 * que simula el acceso a datos.
 */
public class VentaDAOMock implements IVentaDAO {

    // Lista que simula una base de datos en memoria
    private final List<Venta> ventas = new ArrayList<>();

    @Override
    public void crearVenta(Venta venta) {

        ventas.add(venta);

        System.out.println("Venta guardada correctamente.");
    }

    @Override
    public Venta buscarVenta(int id) {

        for (Venta venta : ventas) {

            if (venta.getIdVenta() == id) {
                return venta;
            }
        }

        return null;
    }

    @Override
    public void actualizarVenta(Venta venta) {

        for (int i = 0; i < ventas.size(); i++) {

            if (ventas.get(i).getIdVenta() == venta.getIdVenta()) {

                ventas.set(i, venta);

                System.out.println("Venta actualizada.");

                return;
            }
        }
    }

    @Override
    public List<Venta> listarVentas() {

        return ventas;
    }
}