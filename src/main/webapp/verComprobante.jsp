    <%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <%@ page import="pe.utp.paladart.domain.Comprobante" %>
    <%@ page import="pe.utp.paladart.domain.Usuario" %>
    <%@ page import="pe.utp.paladart.domain.Rol" %>
    <%@ page import="java.time.format.DateTimeFormatter" %>

    <%
        /*
         * Recupera el comprobante enviado
         * desde ComprobanteServlet.
         */
        Comprobante comprobante =
                (Comprobante) request.getAttribute(
                        "comprobante"
                );

        /*
         * Formato utilizado para mostrar
         * la fecha y hora de emisión.
         */
        DateTimeFormatter formatoFecha =
                DateTimeFormatter.ofPattern(
                        "dd/MM/yyyy HH:mm"
                );

        /*
         * Recupera el usuario de la sesión.
         */
        Usuario usuario =
                (Usuario) session.getAttribute(
                        "usuarioSesion"
                );

        String nombreUsuario =
                usuario != null
                        ? usuario.getNombre()
                        : "Usuario";

        boolean esAdministrador =
                usuario != null
                        && usuario.getRol() == Rol.ADMIN;

        /*
         * Evita que la página falle si se intenta
         * abrir sin haber enviado un comprobante.
         */
        if (comprobante == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/ventas?accion=listar"
            );

            return;
        }

        /*
         * Documento mostrado en pantalla.
         */
        String documentoMostrado =
                comprobante.getDocumentoCliente() == null
                        || comprobante.getDocumentoCliente().isBlank()
                        ? "No registrado"
                        : comprobante.getDocumentoCliente();

        /*
         * Etiqueta según el tipo de comprobante.
         */
        String etiquetaDocumento =
                "FACTURA".equalsIgnoreCase(
                        comprobante.getTipo()
                )
                        ? "RUC"
                        : "DNI";
    %>

    <!DOCTYPE html>

    <html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            <%= comprobante.getTipo() %>
            <%= comprobante.getSerie() %>-<%= comprobante.getNumero() %>
            | Paladart
        </title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
              rel="stylesheet">

        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
              rel="stylesheet">

        <!-- CSS propio -->
        <link rel="stylesheet"
              href="<%= request.getContextPath() %>/css/styles.css?v=6">

    </head>

    <body class="paladart-body">

    <div class="app-layout">

        <!-- =====================================================
             MENÚ LATERAL
             ===================================================== -->

        <aside class="app-sidebar no-print">

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

                    <span>Inicio</span>

                </a>

                <a href="<%= request.getContextPath() %>/ventas">

                    <i class="bi bi-cart-plus-fill"></i>

                    <span>Nueva venta</span>

                </a>

                <a href="<%= request.getContextPath() %>/ventas?accion=listar">

                    <i class="bi bi-card-list"></i>

                    <span>Ventas</span>

                </a>

                <a href="#"
                   class="active">

                    <i class="bi bi-receipt-cutoff"></i>

                    <span>Comprobantes</span>

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
            <header class="app-topbar no-print">

                <button type="button"
                        class="topbar-menu-button">

                    <i class="bi bi-list"></i>

                </button>

                <div class="topbar-sale-information">

                    <span>Venta asociada</span>

                    <strong>
                        VTA-<%= String.format(
                                "%06d",
                                comprobante.getIdVenta()
                        ) %>
                    </strong>

                </div>

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

            </header>

            <!-- Área principal -->
            <main class="page-content voucher-result-page">

                <!-- Encabezado -->
                <div class="page-heading no-print">

                    <div>

                        <h2>Comprobante emitido</h2>

                        <p>
                            El comprobante fue registrado
                            correctamente en PostgreSQL.
                        </p>

                    </div>

                    <div class="page-heading-icon">

                        <i class="bi bi-check-circle-fill"></i>

                    </div>

                </div>

                <!-- Mensaje exitoso -->
                <div class="voucher-success-message no-print">

                    <i class="bi bi-check-circle-fill"></i>

                    <div>

                        <strong>
                            Comprobante generado correctamente
                        </strong>

                        <p>
                            Serie:
                            <%= comprobante.getSerie() %>-<%= comprobante.getNumero() %>
                        </p>

                    </div>

                </div>

                <!-- Contenedor principal -->
                <div class="voucher-result-layout">

                    <!-- Ticket -->
                    <section class="voucher-ticket-wrapper">

                        <article class="voucher-ticket"
                                 id="comprobanteImpresion">

                            <!-- Identidad -->
                            <header class="ticket-header">

                                <div class="ticket-logo">

                                    <i class="bi bi-shop-window"></i>

                                </div>

                                <h1>PALADART</h1>

                                <p class="ticket-brand-subtitle">
                                    RESTAURANTE
                                </p>

                                <p class="ticket-business-info">
                                    Sistema Web de Gestión de Ventas
                                </p>

                            </header>

                            <div class="ticket-separator"></div>

                            <!-- Tipo -->
                            <section class="ticket-document-heading">

                                <h2>
                                    <%= comprobante.getTipo() %>
                                    DE VENTA ELECTRÓNICA
                                </h2>

                                <strong>
                                    <%= comprobante.getSerie() %>-<%= comprobante.getNumero() %>
                                </strong>

                            </section>

                            <div class="ticket-separator"></div>

                            <!-- Información general -->
                            <section class="ticket-information">

                                <div class="ticket-information-row">

                                    <span>Fecha:</span>

                                    <strong>
                                        <%= comprobante
                                                .getFechaEmision()
                                                .format(formatoFecha) %>
                                    </strong>

                                </div>

                                <div class="ticket-information-row">

                                    <span>Venta:</span>

                                    <strong>
                                        VTA-<%= String.format(
                                                "%06d",
                                                comprobante.getIdVenta()
                                        ) %>
                                    </strong>

                                </div>

                                <div class="ticket-information-row">

                                    <span>Cliente:</span>

                                    <strong>
                                        <%= comprobante.getNombreCliente() %>
                                    </strong>

                                </div>

                                <div class="ticket-information-row">

                                    <span><%= etiquetaDocumento %>:</span>

                                    <strong>
                                        <%= documentoMostrado %>
                                    </strong>

                                </div>

                            </section>

                            <div class="ticket-separator"></div>

                            <!-- Detalle -->
                            <section class="ticket-detail">

                                <div class="ticket-detail-header">

                                    <span>Concepto</span>

                                    <span>Monto</span>

                                </div>

                                <div class="ticket-detail-row">

                                    <span>Subtotal</span>

                                    <strong>
                                        S/ <%= String.format(
                                                "%.2f",
                                                comprobante.getSubtotal()
                                        ) %>
                                    </strong>

                                </div>

                                <div class="ticket-detail-row">

                                    <span>IGV (18 %)</span>

                                    <strong>
                                        S/ <%= String.format(
                                                "%.2f",
                                                comprobante.getIgv()
                                        ) %>
                                    </strong>

                                </div>

                            </section>

                            <div class="ticket-separator"></div>

                            <!-- Total -->
                            <section class="ticket-total">

                                <span>TOTAL</span>

                                <strong>
                                    S/ <%= String.format(
                                            "%.2f",
                                            comprobante.getTotal()
                                    ) %>
                                </strong>

                            </section>

                            <div class="ticket-separator"></div>

                            <!-- Pie -->
                            <footer class="ticket-footer">

                                <p>
                                    ¡Gracias por su compra!
                                </p>

                                <small>
                                    Comprobante generado por Paladart
                                </small>

                            </footer>

                        </article>

                    </section>

                    <!-- Panel de información -->
                    <aside class="voucher-result-summary no-print">

                        <section class="content-card">

                            <div class="content-card-header">

                                <div>

                                    <i class="bi bi-clipboard-check"></i>

                                    <span>Resumen</span>

                                </div>

                            </div>

                            <div class="content-card-body">

                                <div class="result-summary-row">

                                    <span>Tipo</span>

                                    <strong>
                                        <%= comprobante.getTipo() %>
                                    </strong>

                                </div>

                                <div class="result-summary-row">

                                    <span>Serie y número</span>

                                    <strong>
                                        <%= comprobante.getSerie() %>-<%= comprobante.getNumero() %>
                                    </strong>

                                </div>

                                <div class="result-summary-row">

                                    <span>Venta</span>

                                    <strong>
                                        VTA-<%= String.format(
                                                "%06d",
                                                comprobante.getIdVenta()
                                        ) %>
                                    </strong>

                                </div>

                                <div class="result-summary-row">

                                    <span>Cliente</span>

                                    <strong>
                                        <%= comprobante.getNombreCliente() %>
                                    </strong>

                                </div>

                                <div class="result-summary-total">

                                    <span>Total</span>

                                    <strong>
                                        S/ <%= String.format(
                                                "%.2f",
                                                comprobante.getTotal()
                                        ) %>
                                    </strong>

                                </div>

                            </div>

                        </section>

                        <div class="voucher-result-actions">

                            <button type="button"
                                    class="btn btn-primary btn-lg"
                                    onclick="window.print()">

                                <i class="bi bi-printer-fill"></i>

                                Imprimir comprobante

                            </button>

                            <a href="<%= request.getContextPath() %>/ventas?accion=listar"
                               class="btn btn-outline-secondary btn-lg">

                                <i class="bi bi-arrow-left-circle"></i>

                                Volver a ventas

                            </a>

                        </div>

                    </aside>

                </div>

            </main>

        </div>

    </div>

    </body>

    </html>