package pe.utp.paladart.presentation.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.utp.paladart.business.VentaService;
import pe.utp.paladart.controller.VentaController;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.IVentaDAO;
import pe.utp.paladart.persistence.VentaDAOMock;
import pe.utp.paladart.util.ExportadorExcel;
import pe.utp.paladart.view.VentaView;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

// Servlet principal para manejar las acciones relacionadas con ventas
@WebServlet("/ventas")
public class VentaServlet extends HttpServlet {

    // DAO simulado en memoria
    private static final IVentaDAO ventaDAO = new VentaDAOMock();

    // Servicio de negocio
    private static final VentaService ventaService = new VentaService(ventaDAO);

    // Vista y controlador usados en la arquitectura del proyecto
    private static final VentaView ventaView = new VentaView();

    private static final VentaController ventaController =
            new VentaController(ventaService, ventaView);

    // Atiende las peticiones GET: mostrar formulario, listar o exportar
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        // Si la acción es listar, envía la lista de ventas al JSP
        if ("listar".equals(accion)) {
            request.setAttribute("ventas", ventaService.listarVentas());
            request.getRequestDispatcher("listarVentas.jsp")
                    .forward(request, response);
            return;
        }

        // Si la acción es exportar, genera el archivo Excel
        if ("exportar".equals(accion)) {
            exportarVentas(response);
            return;
        }

        // Si no hay acción, muestra el formulario de registro
        request.getRequestDispatcher("ventas.jsp")
                .forward(request, response);
    }

    // Atiende las peticiones POST: registrar una nueva venta
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        try {
            // Captura los datos enviados desde el formulario
            double total = Double.parseDouble(request.getParameter("total"));
            String metodoPago = request.getParameter("metodoPago");

            // Genera automáticamente el ID de la venta
            int idVenta = ventaService.obtenerSiguienteId();

            // Crea el objeto Venta
            Venta venta = new Venta(idVenta, total, metodoPago);

            // Registra la venta usando el controlador
            ventaController.registrarVenta(venta);

            // Mensaje de éxito para SweetAlert2
            String mensaje = URLEncoder.encode(
                    "Venta registrada correctamente",
                    StandardCharsets.UTF_8);

            // Redirige al listado de ventas
            response.sendRedirect(
                    "ventas?accion=listar&mensaje=" + mensaje);

        } catch (Exception e) {

            // Mensaje de error para SweetAlert2
            String error = URLEncoder.encode(
                    e.getMessage(),
                    StandardCharsets.UTF_8);

            // Redirige nuevamente al formulario
            response.sendRedirect(
                    "ventas?error=" + error);
        }
    }

    // Método encargado de exportar las ventas a Excel
    private void exportarVentas(HttpServletResponse response)
            throws IOException {

        // Tipo de contenido para archivo Excel
        response.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");

        // Nombre del archivo descargado
        response.setHeader(
                "Content-Disposition",
                "attachment; filename=ReporteVentas.xlsx");

        // Usa la clase utilitaria ExportadorExcel
        ExportadorExcel exportadorExcel = new ExportadorExcel();

        exportadorExcel.generarReporte(
                ventaService.listarVentas(),
                response.getOutputStream());
    }
}