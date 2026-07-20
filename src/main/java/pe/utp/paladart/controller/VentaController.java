package pe.utp.paladart.controller;

import pe.utp.paladart.business.VentaService;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.view.VentaView;

/*
 * Controlador encargado de coordinar
 * el registro de una venta.
 *
 * Recibe la solicitud desde la capa Presentation,
 * envía la venta hacia la capa Business
 * y devuelve el ID generado por PostgreSQL.
 */
public class VentaController {

    /*
     * Servicio que contiene las reglas
     * de negocio relacionadas con las ventas.
     */
    private final VentaService ventaService;

    /*
     * Vista utilizada para mostrar mensajes.
     */
    private final VentaView ventaView;

    /*
     * Constructor que recibe las dependencias
     * mediante inyección por constructor.
     */
    public VentaController(
            VentaService ventaService,
            VentaView ventaView
    ) {
        this.ventaService = ventaService;
        this.ventaView = ventaView;
    }

    /*
     * Registra una venta y devuelve el ID
     * generado automáticamente por PostgreSQL.
     */
    public int registrarVenta(Venta venta) {

        /*
         * El servicio valida y registra la venta.
         *
         * El ID generado viaja desde:
         *
         * PostgreSQL
         *      ↓
         * VentaDAO
         *      ↓
         * VentaService
         *      ↓
         * VentaController
         */
        int idVenta =
                ventaService.registrarVenta(
                        venta
                );

        /*
         * Muestra un mensaje mediante la vista.
         */
        ventaView.mostrarMensaje(
                "Venta procesada correctamente. ID: "
                        + idVenta
        );

        /*
         * Devuelve el ID al Servlet.
         */
        return idVenta;
    }
}