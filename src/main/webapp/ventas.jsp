<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Recibe el mensaje de error enviado desde VentaServlet
    String error = request.getParameter("error");
%>

<html>
<head>
    <title>Registrar Venta</title>

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
            <h2 class="fw-bold text-success">
                <i class="bi bi-plus-circle"></i> Registrar Venta
            </h2>

            <p class="text-muted">
                Ingrese los datos de la venta para registrarla en el sistema.
            </p>

            <hr>

            <!-- Formulario de registro -->
            <form method="post" action="ventas">

                <!-- Campo total -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">
                        <i class="bi bi-cash-coin"></i> Total
                    </label>

                    <input type="number"
                           step="0.01"
                           name="total"
                           class="form-control form-control-lg"
                           placeholder="Ejemplo: 100.50"
                           required>
                </div>

                <!-- Campo método de pago -->
                <div class="mb-4">
                    <label class="form-label fw-semibold">
                        <i class="bi bi-credit-card"></i> Método de Pago
                    </label>

                    <select name="metodoPago" class="form-select form-select-lg" required>
                        <option value="">Seleccione un método de pago</option>
                        <option value="Efectivo">Efectivo</option>
                        <option value="Tarjeta">Tarjeta</option>
                        <option value="Yape">Yape</option>
                        <option value="Plin">Plin</option>
                    </select>
                </div>

                <!-- Botones -->
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-success btn-lg">
                        <i class="bi bi-check-circle"></i> Registrar
                    </button>

                    <a href="index.jsp" class="btn btn-secondary btn-lg">
                        <i class="bi bi-arrow-left-circle"></i> Volver
                    </a>
                </div>

            </form>

        </div>
    </div>

</div>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Alerta de error -->
<% if (error != null) { %>
<script>
    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: '<%= error %>',
        confirmButtonColor: '#dc3545'
    });
</script>
<% } %>

</body>
</html>