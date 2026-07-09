<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Paladart - Inicio</title>

    <!-- Bootstrap para diseño responsivo -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Íconos de Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Estilos propios -->
    <link href="css/styles.css" rel="stylesheet">
</head>
<body>

<!-- Contenedor principal -->
<div class="container mt-5">

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body text-center p-5">

            <!-- Título del sistema -->
            <h1 class="fw-bold text-primary">
                <i class="bi bi-shop"></i> Paladart
            </h1>

            <p class="text-muted fs-5">
                Sistema Web de Gestión de Ventas y Emisión de Comprobantes
            </p>

            <hr>

            <!-- Opciones principales -->
            <div class="row mt-4">

                <div class="col-md-6 mb-3">
                    <a href="ventas" class="btn btn-success btn-lg w-100 p-4">
                        <i class="bi bi-plus-circle"></i><br>
                        Registrar Venta
                    </a>
                </div>

                <div class="col-md-6 mb-3">
                    <a href="ventas?accion=listar" class="btn btn-primary btn-lg w-100 p-4">
                        <i class="bi bi-card-list"></i><br>
                        Ver Ventas
                    </a>
                </div>

            </div>

            <p class="text-muted mt-4 small">
                Proyecto Integrador 1 - Arquitectura por capas, Servlets, JSP, Maven y Apache Tomcat.
            </p>

        </div>
    </div>

</div>

</body>
</html>