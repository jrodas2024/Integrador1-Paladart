<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%@ page import="pe.utp.paladart.domain.Venta" %>
<%@ page import="pe.utp.paladart.domain.Comprobante" %>
<%@ page import="pe.utp.paladart.domain.Usuario" %>
<%@ page import="pe.utp.paladart.domain.Rol" %>

<%
    /*
     * Recupera la lista de ventas enviada
     * desde VentaServlet.
     */
    List<Venta> ventas =
            (List<Venta>) request.getAttribute(
                    "ventas"
            );

    /*
     * Recupera el mapa que relaciona:
     *
     * ID de venta → comprobante
     */
    Map<Integer, Comprobante> comprobantesPorVenta =
            (Map<Integer, Comprobante>) request.getAttribute(
                    "comprobantesPorVenta"
            );

    /*
     * Recupera el usuario almacenado
     * durante el inicio de sesión.
     */
    Usuario usuario =
            (Usuario) session.getAttribute(
                    "usuarioSesion"
            );

    /*
     * Nombre que se mostrará
     * en la barra superior.
     */
    String nombreUsuario =
            usuario != null
                    ? usuario.getNombre()
                    : "Usuario";

    /*
     * Determina si el usuario tiene
     * permisos de administrador.
     */
    boolean esAdministrador =
            usuario != null
                    && usuario.getRol() == Rol.ADMIN;

    /*
     * Mensajes recibidos mediante la URL.
     */
    String mensaje =
            request.getParameter(
                    "mensaje"
            );

    String error =
            request.getParameter(
                    "error"
            );

    /*
     * Evita errores si por alguna razón
     * el Servlet no envió el mapa.
     */
    if (comprobantesPorVenta == null) {
        comprobantesPorVenta =
                new java.util.HashMap<>();
    }
%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Ventas registradas | Paladart</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">

    <!-- CSS propio -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/styles.css?v=4">

</head>

<body class="paladart-body">

<div class="app-layout">

    <!-- =====================================================
         MENÚ LATERAL
         ===================================================== -->

    <aside class="app-sidebar">

        <!-- Identidad de Paladart -->
        <div class="sidebar-brand">

            <div class="sidebar-logo">
                <i class="bi bi-shop-window"></i>
            </div>

            <h1>PALADART</h1>

            <span>RESTAURANTE</span>

        </div>

        <hr class="sidebar-divider">

        <!-- Opciones de navegación -->
        <nav class="sidebar-menu">

            <a href="<%= request.getContextPath() %>/dashboard">

                <i class="bi bi-house-door-fill"></i>

                <span>Dashboard</span>

            </a>

            <a href="<%= request.getContextPath() %>/ventas">

                <i class="bi bi-cart-plus-fill"></i>

                <span>Nueva venta</span>

            </a>

            <a href="<%= request.getContextPath() %>/ventas?accion=listar"
               class="active">

                <i class="bi bi-card-list"></i>

                <span>Ventas</span>

            </a>

            <% if (esAdministrador) { %>

            <a href="<%= request.getContextPath() %>/reportes">

                <i class="bi bi-file-earmark-excel-fill"></i>

                <span>Reportes</span>

            </a>

            <% } %>

        </nav>

        <!-- Pie del menú -->
        <div class="sidebar-footer">

            <div class="sidebar-user-icon">
                <i class="bi bi-person-circle"></i>
            </div>

            <div>

                <strong>PALADART v1.0</strong>

                <small>Sistema de ventas</small>

            </div>

        </div>

    </aside>

    <!-- =====================================================
         CONTENIDO PRINCIPAL
         ===================================================== -->

    <div class="app-content">

        <!-- Barra superior -->
<header class="app-topbar">

    <button type="button"
            class="topbar-menu-button">

        <i class="bi bi-list"></i>

    </button>

    <div class="dashboard-topbar-actions">

        <div class="topbar-user">

            <i class="bi bi-person-circle"></i>

            <div>

                <strong>
                    <%= nombreUsuario %>
                </strong>

                <small>
                    <%= esAdministrador
                            ? "Administrador"
                            : "Vendedor" %>
                </small>

            </div>

        </div>

        <a href="<%= request.getContextPath() %>/logout"
           class="btn btn-outline-danger btn-sm">

            <i class="bi bi-box-arrow-right"></i>

            Cerrar sesión

        </a>

    </div>

</header>

        <!-- Área principal -->
        <main class="page-content">

            <!-- Encabezado -->
            <div class="page-heading">

                <div>

                    <h2>Ventas registradas</h2>

                    <p>
                        Consulte las ventas y los comprobantes
                        generados en el sistema.
                    </p>

                </div>

                <div class="page-heading-actions">

                    <a href="<%= request.getContextPath() %>/ventas"
                       class="btn btn-success">

                        <i class="bi bi-plus-circle-fill"></i>

                        Nueva venta

                    </a>

                    <% if (esAdministrador) { %>

                    <a href="<%= request.getContextPath() %>/ventas?accion=exportar"
                       class="btn btn-warning">

                        <i class="bi bi-file-earmark-excel-fill"></i>

                        Exportar Excel

                    </a>

                    <% } %>

                </div>

            </div>

            <!-- Resumen superior -->
            <div class="sales-statistics">

                <div class="statistic-card">

                    <div class="statistic-icon statistic-icon-blue">

                        <i class="bi bi-receipt"></i>

                    </div>

                    <div>

                        <span>Total de ventas</span>

                        <strong>
                            <%= ventas != null
                                    ? ventas.size()
                                    : 0 %>
                        </strong>

                    </div>

                </div>

                <div class="statistic-card">

                    <div class="statistic-icon statistic-icon-green">

                        <i class="bi bi-file-earmark-check"></i>

                    </div>

                    <div>

                        <span>Con comprobante</span>

                        <strong>
                            <%= comprobantesPorVenta.size() %>
                        </strong>

                    </div>

                </div>

                <div class="statistic-card">

                    <div class="statistic-icon statistic-icon-yellow">

                        <i class="bi bi-hourglass-split"></i>

                    </div>

                    <div>

                        <span>Pendientes</span>

                        <strong>
                            <%
                                int totalVentas =
                                        ventas != null
                                                ? ventas.size()
                                                : 0;

                                int pendientes =
                                        totalVentas
                                                - comprobantesPorVenta.size();
                            %>

                            <%= pendientes %>
                        </strong>

                    </div>

                </div>

            </div>

            <!-- Tarjeta principal -->
            <section class="content-card">

                <div class="content-card-header">

                    <div>

                        <i class="bi bi-table"></i>

                        <span>Listado de ventas</span>

                    </div>

                    <small>

                        <%= ventas != null
                                ? ventas.size()
                                : 0 %>

                        registro(s)

                    </small>

                </div>

                <div class="content-card-body sales-table-container">

                    <% if (ventas == null || ventas.isEmpty()) { %>

                    <!-- Estado cuando no existen ventas -->
                    <div class="empty-state">

                        <div class="empty-state-icon">

                            <i class="bi bi-cart-x"></i>

                        </div>

                        <h3>No existen ventas registradas</h3>

                        <p>
                            Registre la primera venta para
                            comenzar a utilizar el sistema.
                        </p>

                        <a href="<%= request.getContextPath() %>/ventas"
                           class="btn btn-success">

                            <i class="bi bi-plus-circle"></i>

                            Registrar venta

                        </a>

                    </div>

                    <% } else { %>

                    <!-- Tabla de ventas -->
                    <div class="table-responsive">

                        <table class="table sales-table align-middle">

                            <thead>

                            <tr>

                                <th>ID Venta</th>

                                <th>Total</th>

                                <th>Método de pago</th>

                                <th>Estado</th>

                                <th>Comprobante</th>

                                <th class="text-end">
                                    Acciones
                                </th>

                            </tr>

                            </thead>

                            <tbody>

                            <% for (Venta venta : ventas) {

                                Comprobante comprobante =
                                        comprobantesPorVenta.get(
                                                venta.getIdVenta()
                                        );
                            %>

                            <tr>

                                <!-- ID -->
                                <td>

                                    <span class="sale-id">

                                        VTA-<%= String.format(
                                                "%06d",
                                                venta.getIdVenta()
                                        ) %>

                                    </span>

                                </td>

                                <!-- Total -->
                                <td>

                                    <strong class="sale-total">

                                        S/ <%= String.format(
                                                "%.2f",
                                                venta.getTotal()
                                        ) %>

                                    </strong>

                                </td>

                                <!-- Método de pago -->
                                <td>

                                    <span class="payment-method">

                                        <%
                                            String metodo =
                                                    venta.getMetodoPago();

                                            if ("Efectivo".equalsIgnoreCase(
                                                    metodo
                                            )) {
                                        %>

                                        <i class="bi bi-cash-stack"></i>

                                        <% } else if (
                                                "Tarjeta".equalsIgnoreCase(
                                                        metodo
                                                )
                                        ) { %>

                                        <i class="bi bi-credit-card"></i>

                                        <% } else { %>

                                        <i class="bi bi-phone"></i>

                                        <% } %>

                                        <%= metodo %>

                                    </span>

                                </td>

                                <!-- Estado -->
                                <td>

                                    <% if (comprobante == null) { %>

                                    <span class="status-badge status-pending">

                                        <i class="bi bi-clock"></i>

                                        Pendiente

                                    </span>

                                    <% } else { %>

                                    <span class="status-badge status-issued">

                                        <i class="bi bi-check-circle"></i>

                                        Emitido

                                    </span>

                                    <% } %>

                                </td>

                                <!-- Comprobante -->
                                <td>

                                    <% if (comprobante == null) { %>

                                    <span class="text-muted">

                                        Sin comprobante

                                    </span>

                                    <% } else { %>

                                    <div class="voucher-information">

                                        <span class="voucher-type">

                                            <%= comprobante.getTipo() %>

                                        </span>

                                        <strong>

                                            <%= comprobante.getSerie() %>-<%= comprobante.getNumero() %>

                                        </strong>

                                    </div>

                                    <% } %>

                                </td>

                                <!-- Acciones -->
                                <td class="text-end">

                                    <% if (comprobante == null) { %>

                                    <!-- Botón para emitir -->
                                    <a href="<%= request.getContextPath() %>/comprobantes?accion=nuevo&idVenta=<%= venta.getIdVenta() %>&total=<%= venta.getTotal() %>"
                                       class="btn btn-sm btn-success">

                                        <i class="bi bi-file-earmark-plus"></i>

                                        Emitir

                                    </a>

                                    <% } else { %>

                                    <!-- Botón para visualizar -->
                                    <a href="<%= request.getContextPath() %>/comprobantes?accion=ver&idVenta=<%= venta.getIdVenta() %>"
                                       class="btn btn-sm btn-outline-primary">

                                        <i class="bi bi-eye"></i>

                                        Ver comprobante

                                    </a>

                                    <% } %>

                                </td>

                            </tr>

                            <% } %>

                            </tbody>

                        </table>

                    </div>

                    <% } %>

                </div>

            </section>

            <!-- Botones inferiores -->
            <div class="page-bottom-actions">

                <a href="<%= request.getContextPath() %>/ventas"
                   class="btn btn-success">

                    <i class="bi bi-plus-circle"></i>

                    Registrar nueva venta

                </a>

                <a href="<%= request.getContextPath() %>/dashboard"
                   class="btn btn-outline-secondary">

                    <i class="bi bi-arrow-left-circle"></i>

                    Volver al inicio

                </a>

            </div>

        </main>

    </div>

</div>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Mensaje exitoso -->
<% if (mensaje != null && !mensaje.isBlank()) { %>

<script>

    Swal.fire({
        icon: "success",
        title: "Operación realizada",
        text: "<%= mensaje %>",
        confirmButtonText: "Aceptar",
        confirmButtonColor: "#198754"
    });

</script>

<% } %>

<!-- Mensaje de error -->
<% if (error != null && !error.isBlank()) { %>

<script>

    Swal.fire({
        icon: "error",
        title: "Error",
        text: "<%= error %>",
        confirmButtonText: "Entendido",
        confirmButtonColor: "#dc3545"
    });

</script>

<% } %>

</body>

</html>