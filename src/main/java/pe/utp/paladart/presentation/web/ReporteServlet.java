package pe.utp.paladart.presentation.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import pe.utp.paladart.business.ComprobanteService;
import pe.utp.paladart.business.VentaService;
import pe.utp.paladart.domain.Comprobante;
import pe.utp.paladart.domain.Rol;
import pe.utp.paladart.domain.Usuario;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.ComprobanteDAO;
import pe.utp.paladart.persistence.IComprobanteDAO;
import pe.utp.paladart.persistence.IVentaDAO;
import pe.utp.paladart.persistence.VentaDAO;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/*
 * Servlet encargado de preparar la información
 * del módulo de reportes.
 *
 * Consulta ventas y comprobantes almacenados
 * en PostgreSQL y calcula indicadores generales.
 */
@WebServlet("/reportes")
public class ReporteServlet extends HttpServlet {

    /*
     * Dependencias reales del módulo de ventas.
     */
    private final IVentaDAO ventaDAO =
            new VentaDAO();

    private final VentaService ventaService =
            new VentaService(
                    ventaDAO
            );

    /*
     * Dependencias reales del módulo
     * de comprobantes.
     */
    private final IComprobanteDAO comprobanteDAO =
            new ComprobanteDAO();

    private final ComprobanteService comprobanteService =
            new ComprobanteService(
                    comprobanteDAO
            );

    /*
     * Atiende solicitudes GET a /reportes.
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        /*
         * Recupera la sesión existente.
         */
        HttpSession session =
                request.getSession(
                        false
                );

        /*
         * Impide acceder sin iniciar sesión.
         */
        if (session == null
                || session.getAttribute(
                "usuarioSesion"
        ) == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.jsp"
            );

            return;
        }

        /*
         * Recupera el usuario autenticado.
         */
        Usuario usuario =
                (Usuario) session.getAttribute(
                        "usuarioSesion"
                );

        /*
         * Solo el administrador puede
         * consultar los reportes.
         */
        if (usuario.getRol() != Rol.ADMIN) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/dashboard?error=No tiene permisos para consultar reportes"
            );

            return;
        }

        /*
         * Consulta los datos reales
         * almacenados en PostgreSQL.
         */
        List<Venta> ventas =
                ventaService.listarVentas();

        List<Comprobante> comprobantes =
                comprobanteService.listar();

        /*
         * Indicadores principales.
         */
        int numeroVentas =
                ventas.size();

        double ventasTotales = 0.0;
        double ventaMasAlta = 0.0;

        /*
         * Conteo por método de pago.
         *
         * LinkedHashMap conserva el orden
         * en que se agregan los métodos.
         */
        Map<String, Integer> ventasPorMetodo =
                new LinkedHashMap<>();

        ventasPorMetodo.put(
                "Efectivo",
                0
        );

        ventasPorMetodo.put(
                "Tarjeta",
                0
        );

        ventasPorMetodo.put(
                "Yape",
                0
        );

        ventasPorMetodo.put(
                "Plin",
                0
        );

        /*
         * Recorre las ventas para calcular:
         *
         * - Total vendido.
         * - Venta más alta.
         * - Cantidad por método de pago.
         */
        for (Venta venta : ventas) {

            ventasTotales +=
                    venta.getTotal();

            if (venta.getTotal()
                    > ventaMasAlta) {

                ventaMasAlta =
                        venta.getTotal();
            }

            String metodo =
                    venta.getMetodoPago();

            ventasPorMetodo.put(
                    metodo,
                    ventasPorMetodo.getOrDefault(
                            metodo,
                            0
                    ) + 1
            );
        }

        /*
         * Ticket promedio.
         */
        double ticketPromedio =
                numeroVentas > 0
                        ? ventasTotales / numeroVentas
                        : 0.0;

        /*
         * Conteo de comprobantes.
         */
        int cantidadBoletas = 0;
        int cantidadFacturas = 0;

        for (Comprobante comprobante
                : comprobantes) {

            if ("BOLETA".equalsIgnoreCase(
                    comprobante.getTipo()
            )) {

                cantidadBoletas++;

            } else if ("FACTURA".equalsIgnoreCase(
                    comprobante.getTipo()
            )) {

                cantidadFacturas++;
            }
        }

        /*
         * Ventas con comprobante y pendientes.
         */
        int comprobantesEmitidos =
                comprobantes.size();

        int comprobantesPendientes =
                numeroVentas
                        - comprobantesEmitidos;

        if (comprobantesPendientes < 0) {
            comprobantesPendientes = 0;
        }

        /*
         * Envía los indicadores a reportes.jsp.
         */
        request.setAttribute(
                "ventas",
                ventas
        );

        request.setAttribute(
                "numeroVentas",
                numeroVentas
        );

        request.setAttribute(
                "ventasTotales",
                ventasTotales
        );

        request.setAttribute(
                "ticketPromedio",
                ticketPromedio
        );

        request.setAttribute(
                "ventaMasAlta",
                ventaMasAlta
        );

        request.setAttribute(
                "ventasPorMetodo",
                ventasPorMetodo
        );

        request.setAttribute(
                "cantidadBoletas",
                cantidadBoletas
        );

        request.setAttribute(
                "cantidadFacturas",
                cantidadFacturas
        );

        request.setAttribute(
                "comprobantesEmitidos",
                comprobantesEmitidos
        );

        request.setAttribute(
                "comprobantesPendientes",
                comprobantesPendientes
        );

        /*
         * Muestra la página del reporte.
         */
        request.getRequestDispatcher(
                "/reportes.jsp"
        ).forward(
                request,
                response
        );
    }
}