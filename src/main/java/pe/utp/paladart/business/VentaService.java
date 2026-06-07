package pe.utp.paladart.business;

import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.IVentaDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.google.common.base.Preconditions;

/*
 * Clase que contiene las reglas de negocio
 * relacionadas con las ventas.
 */
public class VentaService {
    // Logger para registrar eventos del sistema
    private static final Logger logger =
            LoggerFactory.getLogger(VentaService.class);

    private IVentaDAO ventaDAO;

    /*
     * Inyección de dependencias por constructor.
     */
    public VentaService(IVentaDAO ventaDAO) {
        this.ventaDAO = ventaDAO;
    }

    public void registrarVenta(Venta venta) {

        // Validación con Google Guava: la venta no puede ser nula
        Preconditions.checkNotNull(
                venta,
                "La venta no puede ser nula");

        // Validación con Google Guava: el total debe ser válido
        Preconditions.checkArgument(
                venta.getTotal() > 0,
                "El total debe ser mayor a cero");

        // Validación con Google Guava: debe existir método de pago
        Preconditions.checkArgument(
                venta.getMetodoPago() != null && !venta.getMetodoPago().isBlank(),
                "Debe especificar un método de pago");

        ventaDAO.crearVenta(venta);

        logger.info("Venta registrada correctamente.");
    }
}