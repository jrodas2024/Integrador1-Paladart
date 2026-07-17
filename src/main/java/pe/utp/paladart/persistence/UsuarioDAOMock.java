package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Rol;
import pe.utp.paladart.domain.Usuario;

import java.util.ArrayList;
import java.util.List;

public class UsuarioDAOMock implements IUsuarioDAO {

    private final List<Usuario> usuarios = new ArrayList<>();

    public UsuarioDAOMock() {

        usuarios.add(new Usuario(
                1,
                "Administrador Paladart",
                "admin",
                "admin123",
                Rol.ADMIN
        ));

        usuarios.add(new Usuario(
                2,
                "Vendedor Paladart",
                "vendedor",
                "venta123",
                Rol.VENDEDOR
        ));
    }

    @Override
    public Usuario buscarPorCredenciales(String username, String password) {

        for (Usuario usuario : usuarios) {

            boolean usuarioCorrecto =
                    usuario.getUsername().equalsIgnoreCase(username);

            boolean claveCorrecta =
                    usuario.getPassword().equals(password);

            if (usuarioCorrecto && claveCorrecta) {
                return usuario;
            }
        }

        return null;
    }
}