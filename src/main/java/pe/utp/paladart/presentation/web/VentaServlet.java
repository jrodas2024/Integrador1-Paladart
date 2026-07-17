package pe.utp.paladart.presentation.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.utp.paladart.business.VentaService;
import pe.utp.paladart.controller.VentaController;
import pe.utp.paladart.domain.Rol;
import pe.utp.paladart.domain.Usuario;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.IVentaDAO;
import pe.utp.paladart.persistence.VentaDAOMock;
import pe.utp.paladart.util.ExportadorExcel;
import pe.utp.paladart.view.VentaView;
import pe.utp.paladart.domain.Comprobante;
import pe.utp.paladart.persistence.ComprobanteDAOMock;
import pe.utp.paladart.persistence.IComprobanteDAO;
import pe.utp.paladart.business.ComprobanteService;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/ventas")
public class VentaServlet extends HttpServlet {

    private static final IVentaDAO ventaDAO = new VentaDAOMock();
    private static final VentaService ventaService = new VentaService(ventaDAO);
    private static final VentaView ventaView = new VentaView();

    private static final VentaController ventaController =
            new VentaController(ventaService, ventaView);
    private final IComprobanteDAO comprobanteDAO =
            new ComprobanteDAOMock();

    private final ComprobanteService comprobanteService =
            new ComprobanteService(comprobanteDAO);
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("listar".equals(accion)) {

            List<Venta> ventas =
                    ventaService.listarVentas();

            Map<Integer, Comprobante> comprobantesPorVenta =
                    new HashMap<>();

            for (Venta venta : ventas) {

                Comprobante comprobante =
                        comprobanteService.buscarPorVenta(
                                venta.getIdVenta()
                        );

                if (comprobante != null) {
                    comprobantesPorVenta.put(
                            venta.getIdVenta(),
                            comprobante
                    );
                }
            }

            request.setAttribute(
                    "ventas",
                    ventas
            );

            request.setAttribute(
                    "comprobantesPorVenta",
                    comprobantesPorVenta
            );

            request.getRequestDispatcher(
                    "listarVentas.jsp"
            ).forward(request, response);

            return;
        }

        if ("exportar".equals(accion)) {

            // La exportación está disponible solo para el administrador
            if (!esAdministrador(request)) {
                redirigirSinPermiso(request, response);
                return;
            }

            exportarVentas(response);
            return;
        }

        request.getRequestDispatcher("ventas.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        try {
            double total = Double.parseDouble(
                    request.getParameter("total")
            );

            String metodoPago =
                    request.getParameter("metodoPago");

            int idVenta =
                    ventaService.obtenerSiguienteId();

            Venta venta = new Venta(
                    idVenta,
                    total,
                    metodoPago
            );

            ventaController.registrarVenta(venta);

            String mensaje = URLEncoder.encode(
                    "Venta registrada correctamente",
                    StandardCharsets.UTF_8
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/ventas?accion=listar&mensaje="
                            + mensaje
            );

        } catch (Exception e) {

            String mensajeError =
                    e.getMessage() != null
                            ? e.getMessage()
                            : "No se pudo registrar la venta";

            String error = URLEncoder.encode(
                    mensajeError,
                    StandardCharsets.UTF_8
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/ventas?error="
                            + error
            );
        }
    }

    private boolean esAdministrador(HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session == null) {
            return false;
        }

        Usuario usuario =
                (Usuario) session.getAttribute("usuarioSesion");

        return usuario != null
                && usuario.getRol() == Rol.ADMIN;
    }

    private void redirigirSinPermiso(HttpServletRequest request,
                                     HttpServletResponse response)
            throws IOException {

        String error = URLEncoder.encode(
                "No tiene permisos para exportar el reporte",
                StandardCharsets.UTF_8
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/index.jsp?error="
                        + error
        );
    }

    private void exportarVentas(HttpServletResponse response)
            throws IOException {

        response.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        );

        response.setHeader(
                "Content-Disposition",
                "attachment; filename=ReporteVentas.xlsx"
        );

        ExportadorExcel exportadorExcel =
                new ExportadorExcel();

        exportadorExcel.generarReporte(
                ventaService.listarVentas(),
                response.getOutputStream()
        );
    }

}