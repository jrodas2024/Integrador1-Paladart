<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.utp.paladart.domain.Usuario" %>
<%@ page import="pe.utp.paladart.domain.Rol" %>

<%
    /*
     * Obtiene el mensaje de error enviado
     * desde VentaServlet.
     */
    String error =
            request.getParameter(
                    "error"
            );

    /*
     * Recupera el usuario que inició sesión.
     */
    Usuario usuario =
            (Usuario) session.getAttribute(
                    "usuarioSesion"
            );

    /*
     * Impide acceder a la página
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
     * Nombre mostrado en la barra superior.
     */
    String nombreUsuario =
            usuario.getNombre();

    /*
     * Permite saber si el usuario
     * tiene el rol ADMIN.
     */
    boolean esAdministrador =
            usuario.getRol() == Rol.ADMIN;
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Nueva venta | Paladart</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">

    <!-- CSS del proyecto -->
    <link href="<%= request.getContextPath() %>/css/styles.css"
          rel="stylesheet">
</head>

<body class="paladart-body">

<div class="app-layout">

    <!-- MENÚ LATERAL -->
    <aside class="app-sidebar">

        <!-- Logo -->
        <div class="sidebar-brand">

            <div class="sidebar-logo">
                <i class="bi bi-shop-window"></i>
            </div>

            <h1>PALADART</h1>

            <span>RESTAURANTE</span>
        </div>

        <hr class="sidebar-divider">

        <!-- Opciones -->
        <nav class="sidebar-menu">

            <a href="<%= request.getContextPath() %>/dashboard">
                <i class="bi bi-house-door-fill"></i>
                <span>Dashboard</span>
            </a>

            <a href="<%= request.getContextPath() %>/ventas"
               class="active">
                <i class="bi bi-cart-fill"></i>
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

    <!-- CONTENIDO -->
    <div class="app-content">

        <!-- BARRA SUPERIOR -->
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

        <!-- ÁREA PRINCIPAL -->
        <main class="page-content">

            <!-- Encabezado -->
            <div class="page-heading">

                <div>
                    <h2>Nueva venta</h2>

                    <p>
                        Registre los datos principales
                        de la operación.
                    </p>
                </div>

                <div class="page-heading-icon">
                    <i class="bi bi-cart-plus"></i>
                </div>

            </div>

            <form method="post"
                  action="<%= request.getContextPath() %>/ventas"
                  id="formVenta">

                <div class="row g-4">

                    <!-- DATOS DE LA VENTA -->
                    <div class="col-lg-8">

                        <section class="content-card">

                            <div class="content-card-header">

                                <div>
                                    <i class="bi bi-receipt"></i>
                                    <span>Datos de la venta</span>
                                </div>

                                <small>
                                    Complete los campos obligatorios
                                </small>

                            </div>

                            <div class="content-card-body">

                                <!-- Total -->
                                <div class="mb-4">

                                    <label for="total"
                                           class="form-label fw-semibold">

                                        Total de la venta
                                    </label>

                                    <div class="input-group input-group-lg">

                                        <span class="input-group-text">
                                            S/
                                        </span>

                                        <input type="number"
                                               id="total"
                                               name="total"
                                               step="0.01"
                                               min="0.01"
                                               class="form-control"
                                               placeholder="0.00"
                                               required>

                                    </div>

                                    <div class="form-text">
                                        Ingrese el importe total,
                                        incluyendo IGV.
                                    </div>

                                </div>

                                <!-- Método de pago -->
                                <div class="mb-4">

                                    <label for="metodoPago"
                                           class="form-label fw-semibold">

                                        Método de pago
                                    </label>

                                    <select id="metodoPago"
                                            name="metodoPago"
                                            class="form-select form-select-lg"
                                            required>

                                        <option value="">
                                            Seleccione un método
                                        </option>

                                        <option value="Efectivo">
                                            Efectivo
                                        </option>

                                        <option value="Tarjeta">
                                            Tarjeta
                                        </option>

                                        <option value="Yape">
                                            Yape
                                        </option>

                                        <option value="Plin">
                                            Plin
                                        </option>

                                    </select>

                                </div>

                                <!-- Información -->
                                <div class="information-box">

                                    <i class="bi bi-info-circle-fill"></i>

                                    <div>
                                        <strong>
                                            Registro en PostgreSQL
                                        </strong>

                                        <p>
                                            El identificador de la venta
                                            será generado automáticamente
                                            por la base de datos.
                                        </p>
                                    </div>

                                </div>

                            </div>

                        </section>

                    </div>

                    <!-- RESUMEN -->
                    <div class="col-lg-4">

                        <section class="summary-card">

                            <div class="summary-icon">
                                <i class="bi bi-clipboard-check"></i>
                            </div>

                            <h3>Resumen</h3>

                            <div class="summary-row">

                                <span>Método de pago</span>

                                <strong id="resumenMetodo">
                                    No seleccionado
                                </strong>

                            </div>

                            <div class="summary-total">

                                <span>Total</span>

                                <strong id="resumenTotal">
                                    S/ 0.00
                                </strong>

                            </div>

                            <button type="submit"
                                    class="btn btn-success btn-lg w-100">

                                <i class="bi bi-check-circle-fill"></i>
                                Registrar venta
                            </button>

                            <a href="<%= request.getContextPath() %>/dashboard"
                               class="btn btn-outline-secondary btn-lg w-100 mt-2">

                                <i class="bi bi-x-circle"></i>
                                Cancelar
                            </a>

                        </section>

                    </div>

                </div>

            </form>

        </main>

    </div>

</div>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>

    /*
     * Elementos del formulario.
     */
    const campoTotal =
        document.getElementById("total");

    const campoMetodo =
        document.getElementById("metodoPago");

    const resumenTotal =
        document.getElementById("resumenTotal");

    const resumenMetodo =
        document.getElementById("resumenMetodo");

    /*
     * Actualiza el total mostrado
     * en la tarjeta de resumen.
     */
    campoTotal.addEventListener("input", function () {

        const valor =
            parseFloat(campoTotal.value);

        if (isNaN(valor)) {
            resumenTotal.textContent =
                "S/ 0.00";

            return;
        }

        resumenTotal.textContent =
            "S/ " + valor.toFixed(2);
    });

    /*
     * Actualiza el método de pago
     * seleccionado.
     */
    campoMetodo.addEventListener("change", function () {

        resumenMetodo.textContent =
            campoMetodo.value !== ""
                ? campoMetodo.value
                : "No seleccionado";
    });

</script>

<!-- Mensaje de error -->
<% if (error != null && !error.isBlank()) { %>

<script>

    Swal.fire({
        icon: "error",
        title: "No se pudo registrar",
        text: "<%= error %>",
        confirmButtonText: "Entendido",
        confirmButtonColor: "#dc3545"
    });

</script>

<% } %>

</body>
</html>