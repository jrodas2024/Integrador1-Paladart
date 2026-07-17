package pe.utp.paladart.presentation.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.utp.paladart.business.ComprobanteService;
import pe.utp.paladart.domain.Comprobante;
import pe.utp.paladart.persistence.ComprobanteDAOMock;
import pe.utp.paladart.persistence.IComprobanteDAO;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/comprobantes")
public class ComprobanteServlet extends HttpServlet {

    private static final IComprobanteDAO comprobanteDAO =
            new ComprobanteDAOMock();

    private static final ComprobanteService comprobanteService =
            new ComprobanteService(comprobanteDAO);

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("nuevo".equals(accion)) {
            request.getRequestDispatcher("emitirComprobante.jsp")
                    .forward(request, response);
            return;
        }

        if ("ver".equals(accion)) {
            try {
                int idVenta = Integer.parseInt(
                        request.getParameter("idVenta")
                );

                Comprobante comprobante =
                        comprobanteService.buscarPorVenta(idVenta);

                if (comprobante == null) {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/ventas?accion=listar"
                    );
                    return;
                }

                request.setAttribute("comprobante", comprobante);

                request.getRequestDispatcher("verComprobante.jsp")
                        .forward(request, response);
                return;

            } catch (NumberFormatException e) {
                response.sendRedirect(
                        request.getContextPath() + "/ventas?accion=listar"
                );
                return;
            }
        }

        response.sendRedirect(
                request.getContextPath() + "/index.jsp"
        );
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idVenta = Integer.parseInt(
                    request.getParameter("idVenta")
            );

            double total = Double.parseDouble(
                    request.getParameter("total")
            );

            String tipo =
                    request.getParameter("tipo");

            String nombreCliente =
                    request.getParameter("nombreCliente");

            String documentoCliente =
                    request.getParameter("documentoCliente");

            Comprobante comprobante =
                    comprobanteService.emitir(
                            idVenta,
                            tipo,
                            nombreCliente,
                            documentoCliente,
                            total
                    );

            request.setAttribute(
                    "comprobante",
                    comprobante
            );

            request.getRequestDispatcher("verComprobante.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            String mensaje = e.getMessage() != null
                    ? e.getMessage()
                    : "No se pudo emitir el comprobante";

            String error = URLEncoder.encode(
                    mensaje,
                    StandardCharsets.UTF_8
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/comprobantes?accion=nuevo"
                            + "&idVenta="
                            + request.getParameter("idVenta")
                            + "&total="
                            + request.getParameter("total")
                            + "&error="
                            + error
            );
        }
    }
}