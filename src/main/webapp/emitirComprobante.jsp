<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="pe.utp.paladart.domain.Usuario" %>
<%@ page import="pe.utp.paladart.domain.Rol" %>

<%
    /*
     * Datos enviados desde listarVentas.jsp
     * mediante la URL.
     */
    String idVenta =
            request.getParameter("idVenta");

    String totalParametro =
            request.getParameter("total");

    String error =
            request.getParameter("error");

    /*
     * Convierte el total recibido a double
     * para calcular subtotal e IGV.
     */
    double total = 0.0;

    try {
        total = Double.parseDouble(totalParametro);
    } catch (Exception e) {
        total = 0.0;
    }

    /*
     * Cálculo del subtotal y el IGV.
     *
     * El total ya incluye IGV.
     */
    double subtotal =
            Math.round((total / 1.18) * 100.0) / 100.0;

    double igv =
            Math.round((total - subtotal) * 100.0) / 100.0;

    /*
     * Recupera al usuario de la sesión.
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
     * Evita que un mensaje con comillas
     * rompa el código JavaScript.
     */
    String errorSeguro =
            error == null
                    ? null
                    : error
                    .replace("\\", "\\\\")
                    .replace("'", "\\'")
                    .replace("\r", " ")
                    .replace("\n", " ");
%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Emitir comprobante | Paladart</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">

    <!-- CSS propio de Paladart -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/styles.css?v=5">

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
        <header class="app-topbar">

            <button type="button"
                    class="topbar-menu-button">

                <i class="bi bi-list"></i>

            </button>

            <div class="topbar-sale-information">

                <span>N.º de venta</span>

                <strong>
                    VTA-<%= String.format(
                            "%06d",
                            Integer.parseInt(idVenta)
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
        <main class="page-content">

            <!-- Encabezado -->
            <div class="page-heading">

                <div>

                    <h2>Emitir comprobante</h2>

                    <p>
                        Complete los datos del cliente
                        y seleccione el tipo de comprobante.
                    </p>

                </div>

                <div class="page-heading-icon">

                    <i class="bi bi-receipt-cutoff"></i>

                </div>

            </div>

            <!-- Formulario -->
            <form method="post"
                  action="<%= request.getContextPath() %>/comprobantes"
                  id="formComprobante">

                <!-- Valores que necesita el Servlet -->
                <input type="hidden"
                       name="idVenta"
                       value="<%= idVenta %>">

                <input type="hidden"
                       name="total"
                       value="<%= String.format("%.2f", total) %>">

                <div class="voucher-layout">

                    <!-- =====================================
                         DATOS DEL CLIENTE
                         ===================================== -->

                    <section class="content-card voucher-client-card">

                        <div class="content-card-header">

                            <div>

                                <i class="bi bi-person-vcard"></i>

                                <span>Datos del cliente</span>

                            </div>

                        </div>

                        <div class="content-card-body">

                            <!-- Tipo de comprobante -->
                            <div class="mb-4">

                                <label class="form-label fw-semibold">

                                    Tipo de comprobante

                                </label>

                                <div class="voucher-type-options">

                                    <label class="voucher-option">

                                        <input type="radio"
                                               name="tipo"
                                               value="BOLETA"
                                               id="tipoBoleta"
                                               checked
                                               required>

                                        <span class="voucher-option-content">

                                            <i class="bi bi-receipt"></i>

                                            <strong>Boleta</strong>

                                            <small>
                                                Para persona natural
                                            </small>

                                        </span>

                                    </label>

                                    <label class="voucher-option">

                                        <input type="radio"
                                               name="tipo"
                                               value="FACTURA"
                                               id="tipoFactura"
                                               checked
                                               required>

                                        <span class="voucher-option-content">

                                            <i class="bi bi-file-earmark-text"></i>

                                            <strong>Factura</strong>

                                            <small>
                                                Para empresa o negocio
                                            </small>

                                        </span>

                                    </label>

                                </div>

                            </div>

                            <!-- Documento -->
                            <div class="mb-3">

                                <label for="documentoCliente"
                                       class="form-label fw-semibold"
                                       id="labelDocumento">

                                    DNI

                                </label>

                                <div class="input-group">

                                    <span class="input-group-text">

                                        <i class="bi bi-person-badge"></i>

                                    </span>

                                    <input type="text"
                                           name="documentoCliente"
                                           id="documentoCliente"
                                           class="form-control"
                                           placeholder="Seleccione primero el tipo"
                                           inputmode="numeric"
                                           disabled>

                                </div>

                                <div class="form-text"
                                     id="ayudaDocumento">

                                    Para una boleta, el DNI es opcional.

                                </div>

                            </div>

                            <!-- Nombre -->
                            <div class="mb-3">

                                <label for="nombreCliente"
                                       class="form-label fw-semibold">

                                    Nombre o razón social

                                </label>

                                <div class="input-group">

                                    <span class="input-group-text">

                                        <i class="bi bi-person"></i>

                                    </span>

                                    <input type="text"
                                           name="nombreCliente"
                                           id="nombreCliente"
                                           class="form-control"
                                           placeholder="Ingrese el nombre del cliente"
                                           maxlength="150"
                                           required>

                                </div>

                            </div>

                            <!-- Información -->
                            <div class="information-box voucher-information-box">

                                <i class="bi bi-shield-check"></i>

                                <div>

                                    <strong>
                                        Validación de datos
                                    </strong>

                                    <p id="mensajeValidacion">
                                        Seleccione boleta o factura
                                        para configurar el documento.
                                    </p>

                                </div>

                            </div>

                        </div>

                    </section>

                    <!-- =====================================
                         RESUMEN DE LA VENTA
                         ===================================== -->

                    <section class="content-card voucher-summary-card">

                        <div class="content-card-header">

                            <div>

                                <i class="bi bi-clipboard-data"></i>

                                <span>Resumen de venta</span>

                            </div>

                        </div>

                        <div class="content-card-body">

                            <div class="voucher-sale-number">

                                <span>Venta asociada</span>

                                <strong>
                                    VTA-<%= String.format(
                                            "%06d",
                                            Integer.parseInt(idVenta)
                                    ) %>
                                </strong>

                            </div>

                            <div class="voucher-summary-line">

                                <span>Subtotal</span>

                                <strong>
                                    S/ <%= String.format(
                                            "%.2f",
                                            subtotal
                                    ) %>
                                </strong>

                            </div>

                            <div class="voucher-summary-line">

                                <span>IGV (18 %)</span>

                                <strong>
                                    S/ <%= String.format(
                                            "%.2f",
                                            igv
                                    ) %>
                                </strong>

                            </div>

                            <div class="voucher-summary-total">

                                <span>Total</span>

                                <strong>
                                    S/ <%= String.format(
                                            "%.2f",
                                            total
                                    ) %>
                                </strong>

                            </div>

                            <div class="voucher-payment-note">

                                <i class="bi bi-info-circle"></i>

                                <span>
                                    El total fue registrado previamente
                                    durante la venta.
                                </span>

                            </div>

                        </div>

                    </section>

                    <!-- =====================================
                         VISTA PREVIA
                         ===================================== -->

                    <section class="content-card voucher-preview-card">

                        <div class="content-card-header">

                            <div>

                                <i class="bi bi-eye"></i>

                                <span>Vista previa</span>

                            </div>

                        </div>

                        <div class="content-card-body">

                            <div class="voucher-preview">

                                <div class="preview-logo">

                                    <i class="bi bi-shop-window"></i>

                                    <h3>PALADART</h3>

                                    <span>RESTAURANTE</span>

                                </div>

                                <div class="preview-divider"></div>

                                <h4 id="previewTipo">
                                    COMPROBANTE
                                </h4>

                                <p class="preview-number">
                                    VTA-<%= String.format(
                                            "%06d",
                                            Integer.parseInt(idVenta)
                                    ) %>
                                </p>

                                <div class="preview-customer">

                                    <div>

                                        <span>Cliente:</span>

                                        <strong id="previewCliente">
                                            Por completar
                                        </strong>

                                    </div>

                                    <div>

                                        <span id="previewDocumentoLabel">
                                            Documento:
                                        </span>

                                        <strong id="previewDocumento">
                                            —
                                        </strong>

                                    </div>

                                </div>

                                <div class="preview-divider"></div>

                                <div class="preview-amount-row">

                                    <span>Subtotal</span>

                                    <strong>
                                        S/ <%= String.format(
                                                "%.2f",
                                                subtotal
                                        ) %>
                                    </strong>

                                </div>

                                <div class="preview-amount-row">

                                    <span>IGV</span>

                                    <strong>
                                        S/ <%= String.format(
                                                "%.2f",
                                                igv
                                        ) %>
                                    </strong>

                                </div>

                                <div class="preview-total-row">

                                    <span>Total</span>

                                    <strong>
                                        S/ <%= String.format(
                                                "%.2f",
                                                total
                                        ) %>
                                    </strong>

                                </div>

                                <p class="preview-thanks">
                                    ¡Gracias por su compra!
                                </p>

                            </div>

                        </div>

                    </section>

                </div>

                <!-- Botones -->
                <div class="voucher-actions">

                    <a href="<%= request.getContextPath() %>/ventas?accion=listar"
                       class="btn btn-outline-secondary btn-lg">

                        <i class="bi bi-x-circle"></i>

                        Cancelar

                    </a>

                    <button type="submit"
                            class="btn btn-success btn-lg">

                        <i class="bi bi-check-circle-fill"></i>

                        Emitir comprobante

                    </button>

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
    const tipoBoleta =
        document.getElementById("tipoBoleta");

    const tipoFactura =
        document.getElementById("tipoFactura");

    const campoDocumento =
        document.getElementById("documentoCliente");

    const campoNombre =
        document.getElementById("nombreCliente");

    const etiquetaDocumento =
        document.getElementById("labelDocumento");

    const ayudaDocumento =
        document.getElementById("ayudaDocumento");

    const mensajeValidacion =
        document.getElementById("mensajeValidacion");

    const previewTipo =
        document.getElementById("previewTipo");

    const previewCliente =
        document.getElementById("previewCliente");

    const previewDocumento =
        document.getElementById("previewDocumento");

    const previewDocumentoLabel =
        document.getElementById("previewDocumentoLabel");

    const formulario =
        document.getElementById("formComprobante");

    /*
     * Configura completamente el formulario
     * según el radio que esté seleccionado.
     */
    function sincronizarTipoComprobante() {

        /*
         * Limpia el valor anterior cuando se cambia
         * entre boleta y factura.
         */
        campoDocumento.disabled = false;
        campoDocumento.setCustomValidity("");

        if (tipoFactura.checked) {

            /*
             * Configuración para factura.
             */
            etiquetaDocumento.textContent =
                "RUC";

            campoDocumento.placeholder =
                "Ingrese el RUC de 11 dígitos";

            campoDocumento.required =
                true;

            campoDocumento.setAttribute(
                "required",
                "required"
            );

            campoDocumento.setAttribute(
                "minlength",
                "11"
            );

            campoDocumento.setAttribute(
                "maxlength",
                "11"
            );

            campoDocumento.setAttribute(
                "pattern",
                "[0-9]{11}"
            );

            campoDocumento.title =
                "El RUC debe tener exactamente 11 dígitos";

            ayudaDocumento.textContent =
                "La factura requiere un RUC de 11 dígitos.";

            mensajeValidacion.textContent =
                "Para emitir una factura, el RUC es obligatorio.";

            previewTipo.textContent =
                "FACTURA";

            previewDocumentoLabel.textContent =
                "RUC:";

        } else {

            /*
             * Configuración para boleta.
             */
            etiquetaDocumento.textContent =
                "DNI";

            campoDocumento.placeholder =
                "Ingrese el DNI de 8 dígitos";

            /*
             * El DNI no es obligatorio para boleta.
             */
            campoDocumento.required =
                false;

            campoDocumento.removeAttribute(
                "required"
            );

            /*
             * Se elimina completamente la longitud mínima
             * heredada de la factura.
             */
            campoDocumento.removeAttribute(
                "minlength"
            );

            campoDocumento.setAttribute(
                "maxlength",
                "8"
            );

            /*
             * Si el usuario escribe un DNI,
             * debe tener exactamente 8 dígitos.
             * El campo vacío sigue siendo válido
             * porque ya no tiene required.
             */
            campoDocumento.setAttribute(
                "pattern",
                "[0-9]{8}"
            );

            campoDocumento.title =
                "El DNI debe tener exactamente 8 dígitos";

            ayudaDocumento.textContent =
                "Para una boleta, el DNI es opcional.";

            mensajeValidacion.textContent =
                "Si ingresa un DNI, debe contener 8 dígitos.";

            previewTipo.textContent =
                "BOLETA";

            previewDocumentoLabel.textContent =
                "DNI:";
        }

        previewDocumento.textContent =
            "—";
    }

    /*
     * Ejecuta la sincronización cada vez
     * que se cambia el tipo.
     */
    tipoBoleta.addEventListener(
        "change",
        sincronizarTipoComprobante
    );

    tipoFactura.addEventListener(
        "change",
        sincronizarTipoComprobante
    );

    /*
     * También se ejecuta con click.
     * Esto evita problemas si el navegador
     * restaura un estado anterior del formulario.
     */
    tipoBoleta.addEventListener(
        "click",
        sincronizarTipoComprobante
    );

    tipoFactura.addEventListener(
        "click",
        sincronizarTipoComprobante
    );

    /*
     * Actualiza el cliente en la vista previa.
     */
    campoNombre.addEventListener(
        "input",
        function () {

            const nombre =
                campoNombre.value.trim();

            previewCliente.textContent =
                nombre !== ""
                    ? nombre
                    : "Por completar";
        }
    );

    /*
     * Permite únicamente números en DNI o RUC.
     */
    campoDocumento.addEventListener(
        "input",
        function () {

            campoDocumento.value =
                campoDocumento.value.replace(
                    /\D/g,
                    ""
                );

            previewDocumento.textContent =
                campoDocumento.value !== ""
                    ? campoDocumento.value
                    : "—";
        }
    );



    /*
     * Configuración inicial de la página.
     * Como Boleta comienza marcada, todo debe
     * mostrarse inicialmente como boleta.
     */
    sincronizarTipoComprobante();

</script>

<% if (errorSeguro != null && !errorSeguro.isBlank()) { %>

<script>

    Swal.fire({
        icon: "error",
        title: "No se pudo emitir",
        text: '<%= errorSeguro %>',
        confirmButtonText: "Entendido",
        confirmButtonColor: "#dc3545"
    });

</script>

<% } %>

</body>

</html>