package pe.utp.paladart.presentation.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import pe.utp.paladart.business.ComprobanteService;
import pe.utp.paladart.business.VentaService;
import pe.utp.paladart.controller.VentaController;
import pe.utp.paladart.domain.Comprobante;
import pe.utp.paladart.domain.Rol;
import pe.utp.paladart.domain.Usuario;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.ComprobanteDAO;
import pe.utp.paladart.persistence.IComprobanteDAO;
import pe.utp.paladart.persistence.IVentaDAO;
import pe.utp.paladart.persistence.VentaDAO;
import pe.utp.paladart.util.ExportadorExcel;
import pe.utp.paladart.view.VentaView;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*
 * Servlet encargado de recibir las solicitudes
 * relacionadas con las ventas.
 *
 * Esta clase pertenece a la capa Presentation.
 */
@WebServlet("/ventas")
public class VentaServlet extends HttpServlet {

    /*
     * Implementación real del DAO de ventas.
     *
     * A partir de este punto, las ventas ya no
     * se almacenan en memoria, sino en PostgreSQL.
     */
    private final IVentaDAO ventaDAO =
            new VentaDAO();

    /*
     * Servicio que contiene las reglas
     * de negocio de las ventas.
     */
    private final VentaService ventaService =
            new VentaService(
                    ventaDAO
            );

    /*
     * Vista utilizada por el controlador.
     */
    private final VentaView ventaView =
            new VentaView();

    /*
     * Controlador que comunica la presentación
     * con la capa Business.
     */
    private final VentaController ventaController =
            new VentaController(
                    ventaService,
                    ventaView
            );

    /*
     * Implementación real del DAO de comprobantes.
     */
    private final IComprobanteDAO comprobanteDAO =
            new ComprobanteDAO();

    /*
     * Servicio encargado de aplicar las reglas
     * relacionadas con los comprobantes.
     */
    private final ComprobanteService comprobanteService =
            new ComprobanteService(
                    comprobanteDAO
            );

    /*
     * Atiende solicitudes HTTP GET.
     *
     * Se utiliza para:
     *
     * - Mostrar el formulario.
     * - Listar ventas.
     * - Exportar el reporte a Excel.
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        /*
         * Obtiene la acción enviada en la URL.
         *
         * Ejemplo:
         * /ventas?accion=listar
         */
        String accion =
                request.getParameter(
                        "accion"
                );

        /*
         * Si la acción es listar, consulta las
         * ventas guardadas en PostgreSQL.
         */
        if ("listar".equals(accion)) {

            List<Venta> ventas =
                    ventaService.listarVentas();

            /*
             * Este mapa relaciona:
             *
             * ID de la venta → comprobante
             *
             * Permite que la JSP muestre el comprobante
             * correspondiente a cada venta.
             */
            Map<Integer, Comprobante> comprobantesPorVenta =
                    new HashMap<>();

            /*
             * Recorre todas las ventas encontradas.
             */
            for (Venta venta : ventas) {

                /*
                 * Busca un comprobante utilizando
                 * el ID de la venta.
                 */
                Comprobante comprobante =
                        comprobanteService.buscarPorVenta(
                                venta.getIdVenta()
                        );

                /*
                 * Solo agrega al mapa los comprobantes
                 * que realmente existen.
                 */
                if (comprobante != null) {

                    comprobantesPorVenta.put(
                            venta.getIdVenta(),
                            comprobante
                    );
                }
            }

            /*
             * Envía la lista de ventas hacia la JSP.
             */
            request.setAttribute(
                    "ventas",
                    ventas
            );

            /*
             * Envía el mapa de comprobantes hacia la JSP.
             */
            request.setAttribute(
                    "comprobantesPorVenta",
                    comprobantesPorVenta
            );

            /*
             * Muestra la página con el listado.
             */
            request.getRequestDispatcher(
                    "listarVentas.jsp"
            ).forward(
                    request,
                    response
            );

            /*
             * Finaliza la ejecución del método
             * después de mostrar el listado.
             */
            return;
        }

        /*
         * Si la acción es exportar,
         * genera el reporte de Excel.
         */
        if ("exportar".equals(accion)) {

            /*
             * La exportación está disponible
             * solamente para los administradores.
             */
            if (!esAdministrador(request)) {

                redirigirSinPermiso(
                        request,
                        response
                );

                return;
            }

            exportarVentas(
                    response
            );

            return;
        }

        /*
         * Si no se recibió ninguna acción,
         * muestra el formulario de ventas.
         */
        request.getRequestDispatcher(
                "ventas.jsp"
        ).forward(
                request,
                response
        );
    }

    /*
     * Atiende solicitudes HTTP POST.
     *
     * Se ejecuta cuando el usuario envía
     * el formulario para registrar una venta.
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        try {

            /*
             * Obtiene el total enviado desde el formulario
             * y lo convierte de String a double.
             */
            double total =
                    Double.parseDouble(
                            request.getParameter(
                                    "total"
                            )
                    );

            /*
             * Obtiene el método de pago seleccionado.
             */
            String metodoPago =
                    request.getParameter(
                            "metodoPago"
                    );

            /*
             * Se crea inicialmente la venta con ID 0.
             *
             * El 0 es temporal porque PostgreSQL todavía
             * no ha generado el identificador real.
             *
             * Este valor no se inserta en la base de datos,
             * porque SQL_CREAR_VENTA solamente guarda:
             *
             * - total
             * - metodo_pago
             */
            Venta venta =
                    new Venta(
                            0,
                            total,
                            metodoPago
                    );

            /*
             * Registra la venta mediante el Controller.
             *
             * PostgreSQL genera automáticamente el ID
             * y este valor regresa por las capas:
             *
             * DAO → Service → Controller → Servlet
             */
            int idVenta =
                    ventaController.registrarVenta(
                            venta
                    );

            /*
             * Crea el mensaje que se mostrará
             * después del registro.
             */
            String mensaje =
                    URLEncoder.encode(
                            "Venta registrada correctamente. ID: "
                                    + idVenta,
                            StandardCharsets.UTF_8
                    );

            /*
             * Redirige al listado de ventas.
             */
            response.sendRedirect(
                    request.getContextPath()
                            + "/ventas?accion=listar&mensaje="
                            + mensaje
            );

        } catch (Exception e) {

            /*
             * Obtiene el mensaje real de la excepción.
             *
             * Cuando la excepción no tiene mensaje,
             * utiliza uno general.
             */
            String mensajeError =
                    e.getMessage() != null
                            ? e.getMessage()
                            : "No se pudo registrar la venta";

            /*
             * Codifica el mensaje para colocarlo
             * correctamente dentro de la URL.
             */
            String error =
                    URLEncoder.encode(
                            mensajeError,
                            StandardCharsets.UTF_8
                    );

            /*
             * Regresa al formulario mostrando el error.
             */
            response.sendRedirect(
                    request.getContextPath()
                            + "/ventas?error="
                            + error
            );
        }
    }

    /*
     * Verifica si el usuario que inició sesión
     * tiene el rol ADMIN.
     */
    private boolean esAdministrador(
            HttpServletRequest request
    ) {

        /*
         * Obtiene la sesión existente.
         *
         * false evita crear una nueva sesión
         * cuando el usuario todavía no inició sesión.
         */
        HttpSession session =
                request.getSession(
                        false
                );

        /*
         * Si no existe sesión, el usuario
         * no puede ser administrador.
         */
        if (session == null) {
            return false;
        }

        /*
         * Recupera el usuario almacenado
         * durante el inicio de sesión.
         */
        Usuario usuario =
                (Usuario) session.getAttribute(
                        "usuarioSesion"
                );

        /*
         * Devuelve true solamente cuando:
         *
         * - Existe un usuario en sesión.
         * - Su rol es ADMIN.
         */
        return usuario != null
                && usuario.getRol() == Rol.ADMIN;
    }

    /*
     * Redirige al usuario cuando intenta
     * exportar sin tener permisos.
     */
    private void redirigirSinPermiso(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String error =
                URLEncoder.encode(
                        "No tiene permisos para exportar el reporte",
                        StandardCharsets.UTF_8
                );

        response.sendRedirect(
                request.getContextPath()
                        + "/index.jsp?error="
                        + error
        );
    }

    /*
     * Genera y descarga el reporte de ventas
     * utilizando Apache POI.
     */
    private void exportarVentas(
            HttpServletResponse response
    ) throws IOException {

        /*
         * Indica que la respuesta será
         * un archivo de Microsoft Excel.
         */
        response.setContentType(
                "application/vnd.openxmlformats-officedocument." +
                        "spreadsheetml.sheet"
        );

        /*
         * Indica al navegador que debe descargar
         * el archivo con este nombre.
         */
        response.setHeader(
                "Content-Disposition",
                "attachment; filename=ReporteVentas.xlsx"
        );

        /*
         * Crea el objeto encargado de generar el Excel.
         */
        ExportadorExcel exportadorExcel =
                new ExportadorExcel();

        /*
         * Envía las ventas y el flujo de salida
         * hacia el exportador.
         */
        exportadorExcel.generarReporte(
                ventaService.listarVentas(),
                response.getOutputStream()
        );
    }
}