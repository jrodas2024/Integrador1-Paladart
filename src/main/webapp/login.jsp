<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String error = request.getParameter("error");
%>

<html>
<head>
    <title>Paladart - Iniciar sesión</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">

    <link href="css/styles.css" rel="stylesheet">
</head>

<body class="login-body">

<div class="login-container shadow-lg">

    <div class="login-brand">

        <i class="bi bi-shop-window login-logo"></i>

        <h1>PALADART</h1>
        <p class="brand-subtitle">RESTAURANTE</p>

        <div class="brand-line"></div>

        <h4>Sistema de Ventas</h4>

        <p class="brand-description">
            Control y gestión para tu restaurante
        </p>

    </div>

    <div class="login-form">

        <h2 class="fw-bold">Iniciar sesión</h2>

        <p class="text-muted mb-4">
            Ingresa tus credenciales para continuar
        </p>

        <form method="post" action="login">

            <div class="mb-3">
                <label class="form-label fw-semibold">Usuario</label>

                <div class="input-group input-group-lg">
                    <span class="input-group-text">
                        <i class="bi bi-person"></i>
                    </span>

                    <input type="text"
                           name="username"
                           class="form-control"
                           placeholder="Ingrese su usuario"
                           autocomplete="username"
                           required>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-semibold">Contraseña</label>

                <div class="input-group input-group-lg">
                    <span class="input-group-text">
                        <i class="bi bi-lock"></i>
                    </span>

                    <input type="password"
                           name="password"
                           id="password"
                           class="form-control"
                           placeholder="Ingrese su contraseña"
                           autocomplete="current-password"
                           required>

                    <button type="button"
                            class="btn btn-outline-secondary"
                            onclick="mostrarClave()">

                        <i class="bi bi-eye" id="iconoClave"></i>
                    </button>
                </div>
            </div>

            <button type="submit"
                    class="btn btn-success btn-lg w-100">

                Ingresar
            </button>

        </form>

        <div class="usuarios-prueba mt-4">
            <p class="mb-1"><strong>Administrador:</strong> admin / admin123</p>
            <p class="mb-0"><strong>Vendedor:</strong> vendedor / venta123</p>
        </div>

        <p class="text-center text-muted small mt-5">
            © 2026 Paladart Restaurante
        </p>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    function mostrarClave() {
        const campo = document.getElementById("password");
        const icono = document.getElementById("iconoClave");

        if (campo.type === "password") {
            campo.type = "text";
            icono.className = "bi bi-eye-slash";
        } else {
            campo.type = "password";
            icono.className = "bi bi-eye";
        }
    }
</script>

<% if (error != null) { %>
<script>
    Swal.fire({
        icon: 'error',
        title: 'No se pudo iniciar sesión',
        text: '<%= error %>',
        confirmButtonColor: '#dc3545'
    });
</script>
<% } %>

</body>
</html>