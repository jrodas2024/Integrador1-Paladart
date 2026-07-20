package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Rol;
import pe.utp.paladart.domain.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Implementación de IUsuarioDAO que consulta
 * la información almacenada en PostgreSQL.
 */
public class UsuarioDAO implements IUsuarioDAO {

    private static final String SQL_BUSCAR_CREDENCIALES = """
            SELECT id_usuario, nombre, username, password, rol
            FROM usuarios
            WHERE username = ? AND password = ?
            """;

    @Override
    public Usuario buscarPorCredenciales(
            String username,
            String password
    ) {

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(
                                SQL_BUSCAR_CREDENCIALES
                        )
        ) {

            sentencia.setString(1, username);
            sentencia.setString(2, password);

            try (ResultSet resultado =
                         sentencia.executeQuery()) {

                if (resultado.next()) {

                    return new Usuario(
                            resultado.getInt("id_usuario"),
                            resultado.getString("nombre"),
                            resultado.getString("username"),
                            resultado.getString("password"),
                            Rol.valueOf(
                                    resultado.getString("rol")
                            )
                    );
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Error al buscar el usuario",
                    e
            );
        }

        return null;
    }
}
