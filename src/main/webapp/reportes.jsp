<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%@ page import="pe.utp.paladart.domain.Usuario" %>
<%@ page import="pe.utp.paladart.domain.Rol" %>
<%@ page import="pe.utp.paladart.domain.Venta" %>

<%
    /*
     * Recupera al usuario autenticado.
     */
    Usuario usuario =
            (Usuario) session.getAttribute(
                    "usuarioSesion"
            );

    /*
     * Si no existe una sesión válida,
     * redirige al login.
     */
    if (usuario == null) {

        response.sendRedirect(
                request.getContextPath()
                        + "/login.jsp"
        );

        return;
    }

    /*
     * Solo el administrador puede
     * visualizar el módulo de reportes.
     */
    boolean esAdministrador =
            usuario.getRol() == Rol.ADMIN;

    if (!esAdministrador) {

        response.sendRedirect(
                request.getContextPath()
                        + "/dashboard?error=No tiene permisos para consultar reportes"
        );

        return;
    }

    /*
     * Recupera los datos enviados
     * desde ReporteServlet.
     */
    List<Venta> ventas =
            (List<Venta>) request.getAttribute(
                    "ventas"
            );

    int numeroVentas =
            (Integer) request.getAttribute(
                    "numeroVentas"
            );

    double ventasTotales =
            (Double) request.getAttribute(
                    "ventasTotales"
            );

    double ticketPromedio =
            (Double) request.getAttribute(
                    "ticketPromedio"
            );

    double ventaMasAlta =
            (Double) request.getAttribute(
                    "ventaMasAlta"
            );

    Map<String, Integer> ventasPorMetodo =
            (Map<String, Integer>) request.getAttribute(
                    "ventasPorMetodo"
            );

    int cantidadBoletas =
            (Integer) request.getAttribute(
                    "cantidadBoletas"
            );

    int cantidadFacturas =
            (Integer) request.getAttribute(
                    "cantidadFacturas"
            );

    int comprobantesEmitidos =
            (Integer) request.getAttribute(
                    "comprobantesEmitidos"
            );

    int comprobantesPendientes =
            (Integer) request.getAttribute(
                    "comprobantesPendientes"
            );

    /*
     * Valores de los métodos de pago.
     */
    int ventasEfectivo =
            ventasPorMetodo.getOrDefault(
                    "Efectivo",
                    0
            );

    int ventasTarjeta =
            ventasPorMetodo.getOrDefault(
                    "Tarjeta",
                    0
            );

    int ventasYape =
            ventasPorMetodo.getOrDefault(
                    "Yape",
                    0
            );

    int ventasPlin =
            ventasPorMetodo.getOrDefault(
                    "Plin",
                    0
            );
%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Reportes | Paladart</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">

    <!-- CSS propio -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/styles.css?v=8">

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

            <a href="<%= request.getContextPath() %>/dashboard">

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

            <a href="<%= request.getContextPath() %>/reportes"
               class="active">

                <i class="bi bi-bar-chart-fill"></i>

                <span>Reportes</span>

            </a>

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
                            Administrador
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
        <main class="page-content reports-page">

            <!-- Encabezado -->
            <div class="page-heading">

                <div>

                    <h2>Reportes de ventas</h2>

                    <p>
                        Consulte indicadores y gráficos
                        basados en la información registrada.
                    </p>

                </div>

                <div class="page-heading-actions">

                    <a href="<%= request.getContextPath() %>/ventas?accion=exportar"
                       class="btn btn-success">

                        <i class="bi bi-file-earmark-excel-fill"></i>

                        Exportar Excel

                    </a>

                </div>

            </div>

            <!-- =================================================
                 INDICADORES
                 ================================================= -->

            <section class="report-statistics">

                <article class="report-stat-card report-stat-blue">

                    <div class="report-stat-icon">

                        <i class="bi bi-currency-dollar"></i>

                    </div>

                    <div>

                        <span>Ventas totales</span>

                        <strong>
                            S/ <%= String.format(
                                    "%.2f",
                                    ventasTotales
                            ) %>
                        </strong>

                    </div>

                </article>

                <article class="report-stat-card report-stat-green">

                    <div class="report-stat-icon">

                        <i class="bi bi-receipt"></i>

                    </div>

                    <div>

                        <span>Número de ventas</span>

                        <strong>
                            <%= numeroVentas %>
                        </strong>

                    </div>

                </article>

                <article class="report-stat-card report-stat-orange">

                    <div class="report-stat-icon">

                        <i class="bi bi-calculator"></i>

                    </div>

                    <div>

                        <span>Ticket promedio</span>

                        <strong>
                            S/ <%= String.format(
                                    "%.2f",
                                    ticketPromedio
                            ) %>
                        </strong>

                    </div>

                </article>

                <article class="report-stat-card report-stat-purple">

                    <div class="report-stat-icon">

                        <i class="bi bi-graph-up-arrow"></i>

                    </div>

                    <div>

                        <span>Venta más alta</span>

                        <strong>
                            S/ <%= String.format(
                                    "%.2f",
                                    ventaMasAlta
                            ) %>
                        </strong>

                    </div>

                </article>

            </section>

            <!-- =================================================
                 GRÁFICOS
                 ================================================= -->

            <section class="reports-chart-grid">

                <!-- Métodos de pago -->
                <article class="content-card">

                    <div class="content-card-header">

                        <div>

                            <i class="bi bi-credit-card"></i>

                            <span>Ventas por método de pago</span>

                        </div>

                    </div>

                    <div class="content-card-body chart-container">

                        <canvas id="graficoMetodos"></canvas>

                    </div>

                </article>

                <!-- Tipo de comprobante -->
                <article class="content-card">

                    <div class="content-card-header">

                        <div>

                            <i class="bi bi-pie-chart"></i>

                            <span>Tipos de comprobante</span>

                        </div>

                    </div>

                    <div class="content-card-body chart-container">

                        <canvas id="graficoComprobantes"></canvas>

                    </div>

                </article>

                <!-- Estado de emisión -->
                <article class="content-card">

                    <div class="content-card-header">

                        <div>

                            <i class="bi bi-file-earmark-check"></i>

                            <span>Estado de emisión</span>

                        </div>

                    </div>

                    <div class="content-card-body chart-container">

                        <canvas id="graficoEstado"></canvas>

                    </div>

                </article>

            </section>

            <!-- =================================================
                 TABLA
                 ================================================= -->

            <section class="content-card reports-table-card">

                <div class="content-card-header">

                    <div>

                        <i class="bi bi-table"></i>

                        <span>Detalle de ventas</span>

                    </div>

                    <small>
                        <%= numeroVentas %> registro(s)
                    </small>

                </div>

                <div class="content-card-body reports-table-body">

                    <% if (ventas == null || ventas.isEmpty()) { %>

                    <div class="empty-state">

                        <div class="empty-state-icon">

                            <i class="bi bi-bar-chart"></i>

                        </div>

                        <h3>No existen datos para mostrar</h3>

                        <p>
                            Registre ventas para generar
                            indicadores y reportes.
                        </p>

                    </div>

                    <% } else { %>

                    <div class="table-responsive">

                        <table class="table reports-table align-middle">

                            <thead>

                            <tr>

                                <th>Venta</th>

                                <th>Método de pago</th>

                                <th class="text-end">Total</th>

                            </tr>

                            </thead>

                            <tbody>

                            <% for (Venta venta : ventas) { %>

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

                                <td class="text-end">

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

            </section>

        </main>

    </div>

</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>

    /*
     * Gráfico de métodos de pago.
     */
    const graficoMetodos =
        document.getElementById(
            "graficoMetodos"
        );

    new Chart(
        graficoMetodos,
        {
            type: "bar",

            data: {
                labels: [
                    "Efectivo",
                    "Tarjeta",
                    "Yape",
                    "Plin"
                ],

                datasets: [
                    {
                        label: "Cantidad de ventas",

                        data: [
                            <%= ventasEfectivo %>,
                            <%= ventasTarjeta %>,
                            <%= ventasYape %>,
                            <%= ventasPlin %>
                        ],

                        backgroundColor: [
                            "#18a05d",
                            "#376be8",
                            "#7a55d9",
                            "#ef8519"
                        ],

                        borderRadius: 7
                    }
                ]
            },

            options: {
                responsive: true,
                maintainAspectRatio: false,

                plugins: {
                    legend: {
                        display: false
                    }
                },

                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        }
                    }
                }
            }
        }
    );

    /*
     * Gráfico Boleta / Factura.
     */
    const graficoComprobantes =
        document.getElementById(
            "graficoComprobantes"
        );

    new Chart(
        graficoComprobantes,
        {
            type: "doughnut",

            data: {
                labels: [
                    "Boletas",
                    "Facturas"
                ],

                datasets: [
                    {
                        data: [
                            <%= cantidadBoletas %>,
                            <%= cantidadFacturas %>
                        ],

                        backgroundColor: [
                            "#18a05d",
                            "#376be8"
                        ],

                        borderWidth: 0
                    }
                ]
            },

            options: {
                responsive: true,
                maintainAspectRatio: false,

                plugins: {
                    legend: {
                        position: "bottom"
                    }
                }
            }
        }
    );

    /*
     * Gráfico de comprobantes emitidos
     * y pendientes.
     */
    const graficoEstado =
        document.getElementById(
            "graficoEstado"
        );

    new Chart(
        graficoEstado,
        {
            type: "doughnut",

            data: {
                labels: [
                    "Emitidos",
                    "Pendientes"
                ],

                datasets: [
                    {
                        data: [
                            <%= comprobantesEmitidos %>,
                            <%= comprobantesPendientes %>
                        ],

                        backgroundColor: [
                            "#18a05d",
                            "#f2bf3b"
                        ],

                        borderWidth: 0
                    }
                ]
            },

            options: {
                responsive: true,
                maintainAspectRatio: false,

                plugins: {
                    legend: {
                        position: "bottom"
                    }
                }
            }
        }
    );

</script>

</body>

</html>