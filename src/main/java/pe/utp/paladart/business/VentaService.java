package pe.utp.paladart.business;

import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.IVentaDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.google.common.base.Preconditions;

import java.util.List;

/*
 * Clase que contiene las reglas de negocio
 * relacionadas con las ventas.
 */
public class VentaService {

    private static final Logger logger =
            LoggerFactory.getLogger(VentaService.class);

    private IVentaDAO ventaDAO;

    public VentaService(IVentaDAO ventaDAO) {
        this.ventaDAO = ventaDAO;
    }

    public void registrarVenta(Venta venta) {

        Preconditions.checkNotNull(
                venta,
                "La venta no puede ser nula");

        Preconditions.checkArgument(
                venta.getTotal() > 0,
                "El total debe ser mayor a cero");

        Preconditions.checkArgument(
                venta.getMetodoPago() != null && !venta.getMetodoPago().isBlank(),
                "Debe especificar un método de pago");

        ventaDAO.crearVenta(venta);

        logger.info("Venta registrada correctamente.");
    }

    public List<Venta> listarVentas() {
        logger.info("Consultando lista de ventas registradas.");
        return ventaDAO.listarVentas();
    }
    public int obtenerSiguienteId() {
        return ventaDAO.listarVentas().size() + 1;
    }
}