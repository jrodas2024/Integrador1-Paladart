package pe.utp.paladart.business;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import pe.utp.paladart.domain.Rol;
import pe.utp.paladart.domain.Usuario;
import pe.utp.paladart.persistence.IUsuarioDAO;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class UsuarioServiceTest {

    private IUsuarioDAO usuarioDAO;
    private UsuarioService usuarioService;

    @BeforeEach
    void prepararPrueba() {

        // Se crea un DAO simulado para no depender de datos reales
        usuarioDAO = mock(IUsuarioDAO.class);

        // El servicio recibe el DAO mediante el constructor
        usuarioService = new UsuarioService(usuarioDAO);
    }

    @Test
    void iniciarSesionConCredencialesCorrectas() {

        Usuario usuarioEsperado = new Usuario(
                1,
                "Administrador Paladart",
                "admin",
                "admin123",
                Rol.ADMIN
        );

        // Se define qué debe devolver el DAO simulado
        when(usuarioDAO.buscarPorCredenciales(
                "admin",
                "admin123"
        )).thenReturn(usuarioEsperado);

        Usuario resultado = usuarioService.iniciarSesion(
                "admin",
                "admin123"
        );

        assertThat(resultado).isNotNull();
        assertThat(resultado.getUsername()).isEqualTo("admin");
        assertThat(resultado.getRol()).isEqualTo(Rol.ADMIN);

        // Se comprueba que el servicio consultó al DAO
        verify(usuarioDAO).buscarPorCredenciales(
                "admin",
                "admin123"
        );
    }

    @Test
    void iniciarSesionConCredencialesIncorrectas() {

        when(usuarioDAO.buscarPorCredenciales(
                "desconocido",
                "123456"
        )).thenReturn(null);

        Usuario resultado = usuarioService.iniciarSesion(
                "desconocido",
                "123456"
        );

        assertThat(resultado).isNull();

        verify(usuarioDAO).buscarPorCredenciales(
                "desconocido",
                "123456"
        );
    }

    @Test
    void validarUsuarioObligatorio() {

        IllegalArgumentException error = assertThrows(
                IllegalArgumentException.class,
                () -> usuarioService.iniciarSesion(
                        "",
                        "admin123"
                )
        );

        assertThat(error.getMessage())
                .isEqualTo("Ingrese el usuario");
    }

    @Test
    void validarContrasenaObligatoria() {

        IllegalArgumentException error = assertThrows(
                IllegalArgumentException.class,
                () -> usuarioService.iniciarSesion(
                        "admin",
                        ""
                )
        );

        assertThat(error.getMessage())
                .isEqualTo("Ingrese la contraseña");
    }
}