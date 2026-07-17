package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Usuario;

public interface IUsuarioDAO {

    Usuario buscarPorCredenciales(String username, String password);
}