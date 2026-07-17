package pe.utp.paladart.business;

import com.google.common.base.Preconditions;
import pe.utp.paladart.domain.Usuario;
import pe.utp.paladart.persistence.IUsuarioDAO;

public class UsuarioService {

    private final IUsuarioDAO usuarioDAO;

    public UsuarioService(IUsuarioDAO usuarioDAO) {
        this.usuarioDAO = usuarioDAO;
    }

    public Usuario iniciarSesion(String username, String password) {

        Preconditions.checkArgument(
                username != null && !username.isBlank(),
                "Ingrese el usuario"
        );

        Preconditions.checkArgument(
                password != null && !password.isBlank(),
                "Ingrese la contraseña"
        );

        return usuarioDAO.buscarPorCredenciales(username, password);
    }
}