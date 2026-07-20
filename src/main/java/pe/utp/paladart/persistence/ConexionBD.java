package pe.utp.paladart.persistence;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase encargada de crear la conexión con PostgreSQL.
 * Los datos de conexión se obtienen mediante variables de entorno.
 */
public final class ConexionBD {

    private static final String DB_URL =
            obtenerVariable("DB_URL");

    private static final String DB_USER =
            obtenerVariable("DB_USER");

    private static final String DB_PASSWORD =
            obtenerVariable("DB_PASSWORD");

    private ConexionBD() {
        // Evita que la clase sea instanciada.
    }

    public static Connection obtenerConexion()
            throws SQLException {

        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException(
                    "No se encontró el driver de PostgreSQL",
                    e
            );
        }

        return DriverManager.getConnection(
                DB_URL,
                DB_USER,
                DB_PASSWORD
        );
    }

    private static String obtenerVariable(String nombre) {

        String valor = System.getenv(nombre);

        if (valor == null || valor.isBlank()) {
            throw new IllegalStateException(
                    "No se configuró la variable de entorno: "
                            + nombre
            );
        }

        return valor;
    }
}