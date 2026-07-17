src/main/webapp/emitirComprobante.jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String idVenta = request.getParameter("idVenta");
    String total = request.getParameter("total");
    String error = request.getParameter("error");
%>

<html>
<head>
    <title>Emitir Comprobante</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">

    <link href="css/styles.css" rel="stylesheet">
</head>

<body>

<div class="container mt-5">

    <div class="card shadow border-0 rounded-4">

        <div class="card-body p-4">

            <h2 class="mb-3">
                <i class="bi bi-receipt"></i>
                Emitir comprobante
            </h2>

            <p class="text-muted">
                Complete los datos del cliente y seleccione el tipo de comprobante.
            </p>

            <form method="post" action="comprobantes">

                <input type="hidden"
                       name="idVenta"
                       value="<%= idVenta %>">

                <input type="hidden"
                       name="total"
                       value="<%= total %>">

                <div class="row">

                    <div class="col-md-6 mb-3">
                        <label class="form-label">
                            ID de venta
                        </label>

                        <input type="text"
                               class="form-control"
                               value="<%= idVenta %>"
                               readonly>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">
                            Total
                        </label>

                        <input type="text"
                               class="form-control"
                               value="S/ <%= total %>"
                               readonly>
                    </div>

                </div>

                <div class="mb-3">
                    <label class="form-label">
                        Tipo de comprobante
                    </label>

                    <select name="tipo"
                            id="tipo"
                            class="form-select"
                            onchange="actualizarDocumento()"
                            required>

                        <option value="">
                            Seleccione
                        </option>

                        <option value="BOLETA">
                            Boleta
                        </option>

                        <option value="FACTURA">
                            Factura
                        </option>

                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        Nombre o razón social
                    </label>

                    <input type="text"
                           name="nombreCliente"
                           class="form-control"
                           placeholder="Ingrese el nombre del cliente"
                           required>
                </div>

                <div class="mb-4">
                    <label class="form-label"
                           id="labelDocumento">

                        DNI
                    </label>

                    <input type="text"
                           name="documentoCliente"
                           id="documentoCliente"
                           class="form-control"
                           placeholder="Ingrese el DNI">
                </div>

                <button type="submit"
                        class="btn btn-success">

                    <i class="bi bi-check-circle"></i>
                    Emitir comprobante
                </button>

                <a href="ventas?accion=listar"
                   class="btn btn-secondary">

                    Volver
                </a>

            </form>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    function actualizarDocumento() {

        const tipo =
            document.getElementById("tipo").value;

        const etiqueta =
            document.getElementById("labelDocumento");

        const campo =
            document.getElementById("documentoCliente");

        if (tipo === "FACTURA") {
            etiqueta.textContent = "RUC";
            campo.placeholder = "Ingrese el RUC de 11 dígitos";
            campo.required = true;
            campo.maxLength = 11;
        } else {
            etiqueta.textContent = "DNI";
            campo.placeholder = "Ingrese el DNI de 8 dígitos";
            campo.required = false;
            campo.maxLength = 8;
        }
    }
</script>

<% if (error != null) { %>

<script>
    Swal.fire({
        icon: 'error',
        title: 'No se pudo emitir',
        text: '<%= error %>',
        confirmButtonColor: '#dc3545'
    });
</script>

<% } %>

</body>
</html>