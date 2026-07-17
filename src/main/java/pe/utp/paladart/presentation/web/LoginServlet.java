package pe.utp.paladart.presentation.web;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.utp.paladart.business.UsuarioService;
import pe.utp.paladart.domain.Usuario;
import pe.utp.paladart.persistence.IUsuarioDAO;
import pe.utp.paladart.persistence.UsuarioDAOMock;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final IUsuarioDAO usuarioDAO = new UsuarioDAOMock();

    private final UsuarioService usuarioService =
            new UsuarioService(usuarioDAO);

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            Usuario usuario =
                    usuarioService.iniciarSesion(username, password);

            if (usuario == null) {
                redirigirConError(
                        request,
                        response,
                        "Usuario o contraseña incorrectos"
                );
                return;
            }

            HttpSession session = request.getSession();

            session.setAttribute("usuarioSesion", usuario);

            response.sendRedirect(
                    request.getContextPath() + "/index.jsp"
            );

        } catch (IllegalArgumentException e) {

            redirigirConError(
                    request,
                    response,
                    e.getMessage()
            );
        }
    }

    private void redirigirConError(HttpServletRequest request,
                                   HttpServletResponse response,
                                   String mensaje)
            throws IOException {

        String error = URLEncoder.encode(
                mensaje,
                StandardCharsets.UTF_8
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/login.jsp?error="
                        + error
        );
    }
}