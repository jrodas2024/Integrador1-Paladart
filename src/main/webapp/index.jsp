<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="pe.utp.paladart.domain.Usuario" %>
<%@ page import="pe.utp.paladart.domain.Rol" %>
<%@ page import="pe.utp.paladart.domain.Venta" %>

<%
    /*
     * Recupera el usuario autenticado.
     */
    Usuario usuario =
            (Usuario) session.getAttribute(
                    "usuarioSesion"
            );

    /*
     * Impide acceder al dashboard
     * sin haber iniciado sesión.
     */
    if (usuario == null) {

        response.sendRedirect(
                request.getContextPath()
                        + "/login.jsp"
        );

        return;
    }

    /*
     * Si alguien abre index.jsp directamente,
     * todavía no existirán los indicadores.
     *
     * En ese caso se redirige al Servlet
     * encargado de preparar la información.
     */
    if (request.getAttribute(
            "cantidadVentas"
    ) == null) {

        response.sendRedirect(
                request.getContextPath()
                        + "/dashboard"
        );

        return;
    }

    /*
     * Determina el rol del usuario.
     */
    boolean esAdministrador =
            usuario.getRol() == Rol.ADMIN;

    /*
     * Recupera los indicadores calculados
     * por DashboardServlet.
     */
    int cantidadVentas =
            (Integer) request.getAttribute(
                    "cantidadVentas"
            );

    double totalVendido =
            (Double) request.getAttribute(
                    "totalVendido"
            );

    double ticketPromedio =
            (Double) request.getAttribute(
                    "ticketPromedio"
            );

    double ventaMasAlta =
            (Double) request.getAttribute(
                    "ventaMasAlta"
            );

    int comprobantesEmitidos =
            (Integer) request.getAttribute(
                    "comprobantesEmitidos"
            );

    int comprobantesPendientes =
            (Integer) request.getAttribute(
                    "comprobantesPendientes"
            );

    List<Venta> ventasRecientes =
            (List<Venta>) request.getAttribute(
                    "ventasRecientes"
            );

    /*
     * Mensaje de error recibido mediante URL.
     */
    String error =
            request.getParameter(
                    "error"
            );
%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Dashboard | Paladart</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">

    <!-- CSS propio -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/styles.css?v=7">

</head>

<body class="paladart-body">

<div class="app-layout">

    <!-- =====================================================
         MENÚ LATERAL
         ===================================================== -->

    <aside class="app-sidebar">

        <div class="sidebar-brand">

            <div class="sidebar-logo">
                <i class="bi bi-shop-window"></i>
            </div>

            <h1>PALADART</h1>

            <span>RESTAURANTE</span>

        </div>

        <hr class="sidebar-divider">

        <nav class="sidebar-menu">

            <a href="<%= request.getContextPath() %>/dashboard"
               class="active">

                <i class="bi bi-house-door-fill"></i>

                <span>Dashboard</span>

            </a>

            <a href="<%= request.getContextPath() %>/ventas">

                <i class="bi bi-cart-plus-fill"></i>

                <span>Nueva venta</span>

            </a>

            <a href="<%= request.getContextPath() %>/ventas?accion=listar">

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
         CONTENIDO
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
                            <%= usuario.getNombre() %>
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
        <main class="page-content dashboard-page">

            <!-- Encabezado -->
            <div class="page-heading">

                <div>

                    <h2>Dashboard</h2>

                    <p>
                        Resumen general de las operaciones
                        registradas en Paladart.
                    </p>

                </div>

                <div class="page-heading-icon">

                    <i class="bi bi-speedometer2"></i>

                </div>

            </div>

            <!-- =================================================
                 INDICADORES
                 ================================================= -->

            <section class="dashboard-statistics">

                <!-- Total vendido -->
                <article class="dashboard-stat-card">

                    <div class="dashboard-stat-icon
                                dashboard-stat-blue">

                        <i class="bi bi-currency-dollar"></i>

                    </div>

                    <div>

                        <span>Total vendido</span>

                        <strong>
                            S/ <%= String.format(
                                    "%.2f",
                                    totalVendido
                            ) %>
                        </strong>

                        <small>
                            Monto acumulado
                        </small>

                    </div>

                </article>

                <!-- Cantidad de ventas -->
                <article class="dashboard-stat-card">

                    <div class="dashboard-stat-icon
                                dashboard-stat-green">

                        <i class="bi bi-receipt"></i>

                    </div>

                    <div>

                        <span>Ventas registradas</span>

                        <strong>
                            <%= cantidadVentas %>
                        </strong>

                        <small>
                            Operaciones realizadas
                        </small>

                    </div>

                </article>

                <!-- Comprobantes -->
                <article class="dashboard-stat-card">

                    <div class="dashboard-stat-icon
                                dashboard-stat-purple">

                        <i class="bi bi-file-earmark-check"></i>

                    </div>

                    <div>

                        <span>Comprobantes</span>

                        <strong>
                            <%= comprobantesEmitidos %>
                        </strong>

                        <small>
                            Boletas y facturas
                        </small>

                    </div>

                </article>

                <!-- Pendientes -->
                <article class="dashboard-stat-card">

                    <div class="dashboard-stat-icon
                                dashboard-stat-orange">

                        <i class="bi bi-hourglass-split"></i>

                    </div>

                    <div>

                        <span>Pendientes</span>

                        <strong>
                            <%= comprobantesPendientes %>
                        </strong>

                        <small>
                            Sin comprobante
                        </small>

                    </div>

                </article>

            </section>

            <!-- =================================================
                 ACCESOS RÁPIDOS
                 ================================================= -->

            <section class="content-card dashboard-quick-card">

                <div class="content-card-header">

                    <div>

                        <i class="bi bi-lightning-charge"></i>

                        <span>Accesos rápidos</span>

                    </div>

                </div>

                <div class="content-card-body">

                    <div class="dashboard-quick-actions">

                        <a href="<%= request.getContextPath() %>/ventas"
                           class="dashboard-action
                                  dashboard-action-green">

                            <i class="bi bi-cart-plus-fill"></i>

                            <div>

                                <strong>Registrar venta</strong>

                                <small>
                                    Crear una nueva operación
                                </small>

                            </div>

                        </a>

                        <a href="<%= request.getContextPath() %>/ventas?accion=listar"
                           class="dashboard-action
                                  dashboard-action-blue">

                            <i class="bi bi-card-list"></i>

                            <div>

                                <strong>Consultar ventas</strong>

                                <small>
                                    Revisar registros y comprobantes
                                </small>

                            </div>

                        </a>

                        <% if (esAdministrador) { %>

                        <a href="<%= request.getContextPath() %>/ventas?accion=exportar"
                           class="dashboard-action
                                  dashboard-action-orange">

                            <i class="bi bi-file-earmark-excel-fill"></i>

                            <div>

                                <strong>Exportar Excel</strong>

                                <small>
                                    Descargar reporte de ventas
                                </small>

                            </div>

                        </a>

                        <% } %>

                    </div>

                </div>

            </section>

            <!-- =================================================
                 RESUMEN ADICIONAL
                 ================================================= -->

            <section class="dashboard-secondary-grid">

                <!-- Ventas recientes -->
                <article class="content-card">

                    <div class="content-card-header">

                        <div>

                            <i class="bi bi-clock-history"></i>

                            <span>Ventas recientes</span>

                        </div>

                        <a href="<%= request.getContextPath() %>/ventas?accion=listar"
                           class="dashboard-view-all">

                            Ver todas

                            <i class="bi bi-chevron-right"></i>

                        </a>

                    </div>

                    <div class="content-card-body dashboard-table-body">

                        <% if (ventasRecientes == null
                                || ventasRecientes.isEmpty()) { %>

                        <div class="dashboard-empty">

                            <i class="bi bi-cart-x"></i>

                            <p>
                                Todavía no existen ventas registradas.
                            </p>

                        </div>

                        <% } else { %>

                        <div class="table-responsive">

                            <table class="table
                                          dashboard-recent-table
                                          align-middle">

                                <thead>

                                <tr>

                                    <th>Venta</th>

                                    <th>Método</th>

                                    <th>Total</th>

                                </tr>

                                </thead>

                                <tbody>

                                <% for (Venta venta
                                        : ventasRecientes) { %>

                                <tr>

                                    <td>

                                        <strong>
                                            VTA-<%= String.format(
                                                    "%06d",
                                                    venta.getIdVenta()
                                            ) %>
                                        </strong>

                                    </td>

                                    <td>

                                        <span class="payment-method">

                                            <i class="bi bi-credit-card"></i>

                                            <%= venta.getMetodoPago() %>

                                        </span>

                                    </td>

                                    <td>

                                        <strong>

                                            S/ <%= String.format(
                                                    "%.2f",
                                                    venta.getTotal()
                                            ) %>

                                        </strong>

                                    </td>

                                </tr>

                                <% } %>

                                </tbody>

                            </table>

                        </div>

                        <% } %>

                    </div>

                </article>

                <!-- Indicadores adicionales -->
                <article class="content-card">

                    <div class="content-card-header">

                        <div>

                            <i class="bi bi-bar-chart-line"></i>

                            <span>Indicadores</span>

                        </div>

                    </div>

                    <div class="content-card-body">

                        <div class="dashboard-indicator">

                            <div>

                                <span>Ticket promedio</span>

                                <small>
                                    Promedio por venta
                                </small>

                            </div>

                            <strong>

                                S/ <%= String.format(
                                        "%.2f",
                                        ticketPromedio
                                ) %>

                            </strong>

                        </div>

                        <div class="dashboard-indicator">

                            <div>

                                <span>Venta más alta</span>

                                <small>
                                    Mayor operación registrada
                                </small>

                            </div>

                            <strong>

                                S/ <%= String.format(
                                        "%.2f",
                                        ventaMasAlta
                                ) %>

                            </strong>

                        </div>

                        <div class="dashboard-indicator">

                            <div>

                                <span>Nivel de emisión</span>

                                <small>
                                    Ventas con comprobante
                                </small>

                            </div>

                            <strong>

                                <%
                                    double porcentajeEmision =
                                            cantidadVentas > 0
                                                    ? (
                                                    comprobantesEmitidos
                                                            * 100.0
                                                            / cantidadVentas
                                            )
                                                    : 0.0;
                                %>

                                <%= String.format(
                                        "%.0f",
                                        porcentajeEmision
                                ) %> %

                            </strong>

                        </div>

                    </div>

                </article>

            </section>

            <footer class="dashboard-footer">

                © 2026 Paladart Restaurante.
                Sistema Web de Gestión de Ventas.

            </footer>

        </main>

    </div>

</div>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<% if (error != null && !error.isBlank()) { %>

<script>

    Swal.fire({
        icon: "warning",
        title: "Acceso restringido",
        text: "<%= error %>",
        confirmButtonText: "Entendido",
        confirmButtonColor: "#dc3545"
    });

</script>

<% } %>

</body>

</html>