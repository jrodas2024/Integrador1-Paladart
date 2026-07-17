package pe.utp.paladart.domain;

public class Usuario {

    private final int idUsuario;
    private final String nombre;
    private final String username;
    private final String password;
    private final Rol rol;

    public Usuario(int idUsuario,
                   String nombre,
                   String username,
                   String password,
                   Rol rol) {

        this.idUsuario = idUsuario;
        this.nombre = nombre;
        this.username = username;
        this.password = password;
        this.rol = rol;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public String getNombre() {
        return nombre;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public Rol getRol() {
        return rol;
    }
}