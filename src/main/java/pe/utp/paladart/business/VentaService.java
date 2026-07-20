package pe.utp.paladart.business;

import com.google.common.base.Preconditions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.IVentaDAO;

import java.util.List;

/*
 * Clase de la capa Business.
 *
 * Contiene las reglas de negocio relacionadas
 * con el registro y consulta de ventas.
 *
 * Esta clase no se conecta directamente con PostgreSQL.
 * Para acceder a los datos utiliza la interfaz IVentaDAO.
 */
public class VentaService {

    /*
     * Logger utilizado para registrar eventos
     * importantes del sistema.
     */
    private static final Logger logger =
            LoggerFactory.getLogger(
                    VentaService.class
            );

    /*
     * Dependencia de la capa Persistence.
     *
     * Se utiliza la interfaz IVentaDAO para que
     * el servicio pueda trabajar con:
     *
     * - VentaDAO
     * - VentaDAOMock
     * - Un mock generado con Mockito
     */
    private final IVentaDAO ventaDAO;

    /*
     * Inyección de dependencias por constructor.
     *
     * El servicio recibe el DAO desde otra clase
     * en lugar de crearlo internamente.
     */
    public VentaService(IVentaDAO ventaDAO) {

        /*
         * Valida que el DAO recibido no sea null.
         */
        this.ventaDAO =
                Preconditions.checkNotNull(
                        ventaDAO,
                        "El DAO de ventas no puede ser nulo"
                );
    }

    /*
     * Valida y registra una venta.
     *
     * Devuelve el identificador generado
     * automáticamente por PostgreSQL.
     */
    public int registrarVenta(Venta venta) {

        /*
         * La venta no puede ser null.
         */
        Preconditions.checkNotNull(
                venta,
                "La venta no puede ser nula"
        );

        /*
         * El total debe ser mayor que cero.
         */
        Preconditions.checkArgument(
                venta.getTotal() > 0,
                "El total debe ser mayor a cero"
        );

        /*
         * El método de pago:
         *
         * - No puede ser null.
         * - No puede estar vacío.
         * - No puede contener solamente espacios.
         */
        Preconditions.checkArgument(
                venta.getMetodoPago() != null
                        && !venta.getMetodoPago().isBlank(),
                "Debe especificar un método de pago"
        );

        /*
         * El DAO registra la venta en PostgreSQL
         * y devuelve el ID generado.
         */
        int idVenta =
                ventaDAO.crearVenta(venta);

        /*
         * Registra el resultado en el archivo de logs.
         */
        logger.info(
                "Venta registrada correctamente con ID {}.",
                idVenta
        );

        /*
         * Devuelve el ID generado para que pueda
         * ser utilizado por el Servlet o para
         * emitir posteriormente un comprobante.
         */
        return idVenta;
    }

    /*
     * Obtiene todas las ventas registradas.
     */
    public List<Venta> listarVentas() {

        logger.info(
                "Consultando lista de ventas registradas."
        );

        return ventaDAO.listarVentas();
    }

    /*
     * Busca una venta mediante su identificador.
     */
    public Venta buscarVenta(int idVenta) {

        Preconditions.checkArgument(
                idVenta > 0,
                "El ID de la venta debe ser válido"
        );

        return ventaDAO.buscarVenta(
                idVenta
        );
    }

    /*
     * Valida y actualiza los datos
     * de una venta existente.
     */
    public void actualizarVenta(Venta venta) {

        Preconditions.checkNotNull(
                venta,
                "La venta no puede ser nula"
        );

        Preconditions.checkArgument(
                venta.getIdVenta() > 0,
                "El ID de la venta debe ser válido"
        );

        Preconditions.checkArgument(
                venta.getTotal() > 0,
                "El total debe ser mayor a cero"
        );

        Preconditions.checkArgument(
                venta.getMetodoPago() != null
                        && !venta.getMetodoPago().isBlank(),
                "Debe especificar un método de pago"
        );

        ventaDAO.actualizarVenta(
                venta
        );

        logger.info(
                "Venta con ID {} actualizada correctamente.",
                venta.getIdVenta()
        );
    }
}