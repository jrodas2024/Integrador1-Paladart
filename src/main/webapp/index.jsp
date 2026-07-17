<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.utp.paladart.domain.Usuario" %>
<%@ page import="pe.utp.paladart.domain.Rol" %>

<%
    Usuario usuario =
            (Usuario) session.getAttribute("usuarioSesion");

    boolean esAdministrador =
            usuario != null && usuario.getRol() == Rol.ADMIN;

    String error = request.getParameter("error");
%>

<html>
<head>
    <title>Paladart - Inicio</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">

    <link href="css/styles.css" rel="stylesheet">
</head>

<body>

<nav class="navbar navbar-dark paladart-navbar">
    <div class="container">

        <span class="navbar-brand fw-bold">
            <i class="bi bi-shop"></i> Paladart
        </span>

        <div class="d-flex align-items-center gap-3 text-white">

            <span>
                <i class="bi bi-person-circle"></i>
                <%= usuario.getNombre() %>
                · <%= usuario.getRol() %>
            </span>

            <a href="logout" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-arrow-right"></i>
                Cerrar sesión
            </a>

        </div>
    </div>
</nav>

<div class="container mt-5">

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body text-center p-5">

            <h1 class="fw-bold text-primary">
                <i class="bi bi-shop"></i> Paladart
            </h1>

            <p class="text-muted fs-5">
                Sistema Web de Gestión de Ventas
            </p>

            <hr>

            <div class="row justify-content-center mt-4">

                <div class="col-md-4 mb-3">
                    <a href="ventas"
                       class="btn btn-success btn-lg w-100 p-4">

                        <i class="bi bi-plus-circle fs-2"></i><br>
                        Registrar Venta
                    </a>
                </div>

                <div class="col-md-4 mb-3">
                    <a href="ventas?accion=listar"
                       class="btn btn-primary btn-lg w-100 p-4">

                        <i class="bi bi-card-list fs-2"></i><br>
                        Ver Ventas
                    </a>
                </div>

                <% if (esAdministrador) { %>

                <div class="col-md-4 mb-3">
                    <a href="ventas?accion=exportar"
                       class="btn btn-warning btn-lg w-100 p-4">

                        <i class="bi bi-file-earmark-excel fs-2"></i><br>
                        Exportar Excel
                    </a>
                </div>

                <% } %>

            </div>

            <p class="text-muted mt-4 small">
                Sesión iniciada como <strong><%= usuario.getRol() %></strong>
            </p>

        </div>
    </div>

</div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <% if (error != null) { %>
    <script>
        Swal.fire({
            icon: 'warning',
            title: 'Acceso restringido',
            text: '<%= error %>',
            confirmButtonColor: '#dc3545'
        });
    </script>
    <% } %>
</body>
</html>