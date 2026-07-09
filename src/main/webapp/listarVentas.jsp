<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="pe.utp.paladart.domain.Venta" %>

<%
    // Recibe la lista de ventas enviada desde VentaServlet
    List<Venta> ventas = (List<Venta>) request.getAttribute("ventas");

    // Recibe el mensaje de éxito enviado por URL
    String mensaje = request.getParameter("mensaje");
%>

<html>
<head>
    <title>Ventas Registradas</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Íconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS propio -->
    <link href="css/styles.css" rel="stylesheet">
</head>
<body>

<div class="container mt-5">

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body p-5">

            <!-- Encabezado -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <h2 class="fw-bold text-primary">
                        <i class="bi bi-card-list"></i> Ventas Registradas
                    </h2>

                    <p class="text-muted">
                        Listado de ventas registradas en el sistema Paladart.
                    </p>
                </div>

                <!-- Contador de ventas -->
                <span class="badge bg-success fs-6">
                    Total: <%= ventas != null ? ventas.size() : 0 %>
                </span>
            </div>

            <hr>

            <!-- Tabla de ventas -->
            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-dark">
                    <tr>
                        <th>ID Venta</th>
                        <th>Total</th>
                        <th>Método de Pago</th>
                    </tr>
                    </thead>

                    <tbody>
                    <% if (ventas != null && !ventas.isEmpty()) { %>

                        <% for (Venta venta : ventas) { %>
                        <tr>
                            <td><%= venta.getIdVenta() %></td>
                            <td>S/ <%= venta.getTotal() %></td>
                            <td><%= venta.getMetodoPago() %></td>
                        </tr>
                        <% } %>

                    <% } else { %>

                        <tr>
                            <td colspan="3" class="text-center text-muted">
                                No hay ventas registradas.
                            </td>
                        </tr>

                    <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Botones -->
            <div class="d-flex gap-2 mt-4">
                <a href="ventas" class="btn btn-success">
                    <i class="bi bi-plus-circle"></i> Registrar nueva venta
                </a>

                <a href="ventas?accion=exportar" class="btn btn-warning">
                    <i class="bi bi-file-earmark-excel"></i> Exportar Excel
                </a>

                <a href="index.jsp" class="btn btn-secondary">
                    <i class="bi bi-arrow-left-circle"></i> Volver
                </a>
            </div>

        </div>
    </div>

</div>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Alerta de éxito -->
<% if (mensaje != null) { %>
<script>
    Swal.fire({
        icon: 'success',
        title: 'Registro exitoso',
        text: '<%= mensaje %>',
        confirmButtonColor: '#198754'
    });
</script>
<% } %>

</body>
</html>