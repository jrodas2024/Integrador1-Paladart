package pe.utp.paladart.presentation.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import pe.utp.paladart.business.ComprobanteService;
import pe.utp.paladart.domain.Comprobante;
import pe.utp.paladart.persistence.ComprobanteDAO;
import pe.utp.paladart.persistence.IComprobanteDAO;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/*
 * Servlet encargado de gestionar las solicitudes
 * relacionadas con los comprobantes.
 *
 * Permite:
 *
 * - Mostrar el formulario para emitir un comprobante.
 * - Registrar el comprobante en PostgreSQL.
 * - Consultar y mostrar un comprobante existente.
 */
@WebServlet("/comprobantes")
public class ComprobanteServlet extends HttpServlet {

    /*
     * Implementación real del DAO de comprobantes.
     *
     * Ya no se utiliza ComprobanteDAOMock,
     * porque los datos se guardarán en PostgreSQL.
     */
    private final IComprobanteDAO comprobanteDAO =
            new ComprobanteDAO();

    /*
     * Servicio que contiene las reglas
     * de negocio de los comprobantes.
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
     * - Abrir el formulario de emisión.
     * - Ver un comprobante ya registrado.
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
         * /comprobantes?accion=nuevo
         */
        String accion =
                request.getParameter(
                        "accion"
                );

        /*
         * Abre el formulario para emitir
         * un nuevo comprobante.
         */
        if ("nuevo".equals(accion)) {

            request.getRequestDispatcher(
                    "emitirComprobante.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        /*
         * Busca y muestra un comprobante existente.
         */
        if ("ver".equals(accion)) {

            try {

                /*
                 * Obtiene el ID de la venta enviado
                 * como parámetro en la URL.
                 */
                int idVenta =
                        Integer.parseInt(
                                request.getParameter(
                                        "idVenta"
                                )
                        );

                /*
                 * Busca el comprobante asociado
                 * a la venta.
                 */
                Comprobante comprobante =
                        comprobanteService.buscarPorVenta(
                                idVenta
                        );

                /*
                 * Si la venta todavía no tiene comprobante,
                 * vuelve al listado de ventas.
                 */
                if (comprobante == null) {

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/ventas?accion=listar"
                    );

                    return;
                }

                /*
                 * Envía el comprobante hacia la JSP.
                 */
                request.setAttribute(
                        "comprobante",
                        comprobante
                );

                /*
                 * Muestra la página con el comprobante.
                 */
                request.getRequestDispatcher(
                        "verComprobante.jsp"
                ).forward(
                        request,
                        response
                );

                return;

            } catch (NumberFormatException e) {

                /*
                 * Si el ID recibido no es un número válido,
                 * regresa al listado de ventas.
                 */
                response.sendRedirect(
                        request.getContextPath()
                                + "/ventas?accion=listar"
                );

                return;
            }
        }

        /*
         * Si la acción no es válida,
         * redirige a la página principal.
         */
        response.sendRedirect(
                request.getContextPath()
                        + "/index.jsp"
        );
    }

    /*
     * Atiende solicitudes HTTP POST.
     *
     * Se ejecuta cuando el usuario envía
     * el formulario para emitir un comprobante.
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {

            /*
             * Obtiene el ID de la venta
             * y lo convierte a entero.
             */
            int idVenta =
                    Integer.parseInt(
                            request.getParameter(
                                    "idVenta"
                            )
                    );

            /*
             * Obtiene el total de la venta
             * y lo convierte a double.
             */
            double total =
                    Double.parseDouble(
                            request.getParameter(
                                    "total"
                            )
                    );

            /*
             * Obtiene el tipo de comprobante:
             *
             * - BOLETA
             * - FACTURA
             */
            String tipo =
                    request.getParameter(
                            "tipo"
                    );

            /*
             * Obtiene el nombre o razón social
             * del cliente.
             */
            String nombreCliente =
                    request.getParameter(
                            "nombreCliente"
                    );

            /*
             * Obtiene el DNI o RUC del cliente.
             */
            String documentoCliente =
                    request.getParameter(
                            "documentoCliente"
                    );

            /*
             * El servicio valida los datos,
             * construye el comprobante
             * y lo guarda en PostgreSQL.
             */
            Comprobante comprobante =
                    comprobanteService.emitir(
                            idVenta,
                            tipo,
                            nombreCliente,
                            documentoCliente,
                            total
                    );

            /*
             * Envía el comprobante recién creado
             * hacia la página de visualización.
             */
            request.setAttribute(
                    "comprobante",
                    comprobante
            );

            /*
             * Muestra el comprobante generado.
             */
            request.getRequestDispatcher(
                    "verComprobante.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            /*
             * Obtiene el mensaje de la excepción.
             */
            String mensaje =
                    e.getMessage() != null
                            ? e.getMessage()
                            : "No se pudo emitir el comprobante";

            /*
             * Codifica el mensaje para colocarlo
             * correctamente dentro de la URL.
             */
            String error =
                    URLEncoder.encode(
                            mensaje,
                            StandardCharsets.UTF_8
                    );

            /*
             * Regresa al formulario de emisión
             * conservando el ID de venta y el total.
             */
            response.sendRedirect(
                    request.getContextPath()
                            + "/comprobantes?accion=nuevo"
                            + "&idVenta="
                            + request.getParameter(
                            "idVenta"
                    )
                            + "&total="
                            + request.getParameter(
                            "total"
                    )
                            + "&error="
                            + error
            );
        }
    }
}