<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.utp.paladart.domain.Comprobante" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Comprobante comprobante =
            (Comprobante) request.getAttribute("comprobante");

    DateTimeFormatter formatoFecha =
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<html>
<head>
    <title>Comprobante Emitido</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">

    <link href="css/styles.css" rel="stylesheet">
</head>

<body>

<div class="container mt-5 mb-5">

    <div class="card shadow border-0 rounded-4">

        <div class="card-body p-5">

            <div class="text-center mb-4">

                <h1 class="fw-bold">
                    PALADART
                </h1>

                <p class="mb-1">
                    Restaurante
                </p>

                <hr>

                <h3>
                    <%= comprobante.getTipo() %>
                </h3>

                <p class="fw-bold">
                    <%= comprobante.getSerie() %>
                    -
                    <%= comprobante.getNumero() %>
                </p>

            </div>

            <div class="row mb-4">

                <div class="col-md-6">

                    <p>
                        <strong>Cliente:</strong>
                        <%= comprobante.getNombreCliente() %>
                    </p>

                    <p>
                        <strong>Documento:</strong>
                        <%= comprobante.getDocumentoCliente().isBlank()
                                ? "No registrado"
                                : comprobante.getDocumentoCliente() %>
                    </p>

                </div>

                <div class="col-md-6">

                    <p>
                        <strong>Venta:</strong>
                        <%= comprobante.getIdVenta() %>
                    </p>

                    <p>
                        <strong>Fecha:</strong>
                        <%= comprobante.getFechaEmision()
                                .format(formatoFecha) %>
                    </p>

                </div>

            </div>

            <table class="table table-bordered">

                <tr>
                    <th>Concepto</th>
                    <th class="text-end">Monto</th>
                </tr>

                <tr>
                    <td>Subtotal</td>
                    <td class="text-end">
                        S/ <%= String.format("%.2f",
                            comprobante.getSubtotal()) %>
                    </td>
                </tr>

                <tr>
                    <td>IGV</td>
                    <td class="text-end">
                        S/ <%= String.format("%.2f",
                            comprobante.getIgv()) %>
                    </td>
                </tr>

                <tr class="table-success fw-bold">
                    <td>Total</td>
                    <td class="text-end">
                        S/ <%= String.format("%.2f",
                            comprobante.getTotal()) %>
                    </td>
                </tr>

            </table>

            <div class="text-center mt-4">

                <button type="button"
                        class="btn btn-primary"
                        onclick="window.print()">

                    <i class="bi bi-printer"></i>
                    Imprimir
                </button>

                <a href="ventas?accion=listar"
                   class="btn btn-secondary">

                    Volver a ventas
                </a>

            </div>

        </div>
    </div>
</div>

</body>
</html>