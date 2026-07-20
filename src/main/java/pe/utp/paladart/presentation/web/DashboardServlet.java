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
import pe.utp.paladart.domain.Usuario;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.ComprobanteDAO;
import pe.utp.paladart.persistence.IComprobanteDAO;
import pe.utp.paladart.persistence.IVentaDAO;
import pe.utp.paladart.persistence.VentaDAO;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/*
 * Servlet encargado de preparar la información
 * que se mostrará en el dashboard principal.
 *
 * Consulta las ventas y comprobantes registrados
 * en PostgreSQL y calcula indicadores generales.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    /*
     * DAO real de ventas.
     */
    private final IVentaDAO ventaDAO =
            new VentaDAO();

    /*
     * Servicio de ventas.
     */
    private final VentaService ventaService =
            new VentaService(
                    ventaDAO
            );

    /*
     * DAO real de comprobantes.
     */
    private final IComprobanteDAO comprobanteDAO =
            new ComprobanteDAO();

    /*
     * Servicio de comprobantes.
     */
    private final ComprobanteService comprobanteService =
            new ComprobanteService(
                    comprobanteDAO
            );

    /*
     * Atiende las solicitudes GET
     * realizadas a /dashboard.
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        /*
         * Obtiene la sesión existente.
         *
         * false evita crear una nueva sesión
         * cuando el usuario no inició sesión.
         */
        HttpSession session =
                request.getSession(
                        false
                );

        /*
         * Si no existe una sesión válida,
         * redirige al formulario de acceso.
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
         * Recupera todas las ventas almacenadas
         * en PostgreSQL.
         */
        List<Venta> ventas =
                ventaService.listarVentas();

        /*
         * Recupera todos los comprobantes
         * almacenados en PostgreSQL.
         */
        List<Comprobante> comprobantes =
                comprobanteService.listar();

        /*
         * Calcula la cantidad de ventas.
         */
        int cantidadVentas =
                ventas.size();

        /*
         * Calcula la suma de los montos
         * de todas las ventas.
         */
        double totalVendido = 0.0;

        /*
         * Obtiene también la venta de mayor monto.
         */
        double ventaMasAlta = 0.0;

        for (Venta venta : ventas) {

            totalVendido +=
                    venta.getTotal();

            if (venta.getTotal()
                    > ventaMasAlta) {

                ventaMasAlta =
                        venta.getTotal();
            }
        }

        /*
         * Calcula el ticket promedio.
         *
         * Se evita dividir entre cero cuando
         * todavía no existen ventas.
         */
        double ticketPromedio =
                cantidadVentas > 0
                        ? totalVendido / cantidadVentas
                        : 0.0;

        /*
         * Cantidad de comprobantes emitidos.
         */
        int comprobantesEmitidos =
                comprobantes.size();

        /*
         * Las ventas pendientes son aquellas
         * que todavía no tienen comprobante.
         */
        int comprobantesPendientes =
                cantidadVentas
                        - comprobantesEmitidos;

        /*
         * Evita mostrar un resultado negativo
         * en caso de datos inconsistentes.
         */
        if (comprobantesPendientes < 0) {
            comprobantesPendientes = 0;
        }

        /*
         * Crea una copia de la lista para
         * obtener las ventas más recientes.
         *
         * VentaDAO devuelve las ventas ordenadas
         * por id_venta de menor a mayor.
         */
        List<Venta> ventasRecientes =
                new ArrayList<>(
                        ventas
                );

        /*
         * Invierte la lista para colocar primero
         * las ventas con ID más alto.
         */
        Collections.reverse(
                ventasRecientes
        );

        /*
         * Muestra como máximo cinco ventas.
         */
        if (ventasRecientes.size() > 5) {

            ventasRecientes =
                    new ArrayList<>(
                            ventasRecientes.subList(
                                    0,
                                    5
                            )
                    );
        }

        /*
         * Envía los indicadores hacia index.jsp.
         */
        request.setAttribute(
                "cantidadVentas",
                cantidadVentas
        );

        request.setAttribute(
                "totalVendido",
                totalVendido
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
                "comprobantesEmitidos",
                comprobantesEmitidos
        );

        request.setAttribute(
                "comprobantesPendientes",
                comprobantesPendientes
        );

        request.setAttribute(
                "ventasRecientes",
                ventasRecientes
        );

        /*
         * Envía la solicitud hacia la JSP.
         *
         * Se utiliza forward porque los datos
         * están almacenados como atributos
         * dentro del request.
         */
        request.getRequestDispatcher(
                "/index.jsp"
        ).forward(
                request,
                response
        );
    }
}