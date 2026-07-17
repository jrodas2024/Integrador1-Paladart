package pe.utp.paladart.presentation.web;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class FiltroAutenticacion implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest,
                         ServletResponse servletResponse,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request =
                (HttpServletRequest) servletRequest;

        HttpServletResponse response =
                (HttpServletResponse) servletResponse;

        String ruta = request.getRequestURI();
        String contexto = request.getContextPath();

        boolean recursoPublico =
                ruta.equals(contexto + "/login.jsp")
                        || ruta.equals(contexto + "/login")
                        || ruta.startsWith(contexto + "/css/")
                        || ruta.startsWith(contexto + "/js/")
                        || ruta.startsWith(contexto + "/images/");

        HttpSession session = request.getSession(false);

        boolean sesionActiva =
                session != null
                        && session.getAttribute("usuarioSesion") != null;

        if (recursoPublico || sesionActiva) {
            chain.doFilter(request, response);
            return;
        }

        response.sendRedirect(contexto + "/login.jsp");
    }
}