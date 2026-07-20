package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Venta;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

/*
 * Implementación real del DAO de ventas.
 *
 * Esta clase pertenece a la capa Persistence
 * y se encarga de comunicarse directamente
 * con la base de datos PostgreSQL.
 */
public class VentaDAO implements IVentaDAO {

    /*
     * Consulta SQL para registrar una nueva venta.
     *
     * La columna id_venta no se incluye porque
     * PostgreSQL la genera automáticamente.
     *
     * RETURNING id_venta permite recuperar el
     * identificador generado después del INSERT.
     */
    private static final String SQL_CREAR_VENTA =
            "INSERT INTO ventas (total, metodo_pago) " +
                    "VALUES (?, ?) RETURNING id_venta";

    /*
     * Consulta SQL para buscar una venta
     * mediante su identificador.
     */
    private static final String SQL_BUSCAR_VENTA =
            "SELECT id_venta, total, metodo_pago " +
                    "FROM ventas " +
                    "WHERE id_venta = ?";

    /*
     * Consulta SQL para actualizar los datos
     * de una venta existente.
     */
    private static final String SQL_ACTUALIZAR_VENTA =
            "UPDATE ventas " +
                    "SET total = ?, metodo_pago = ? " +
                    "WHERE id_venta = ?";

    /*
     * Consulta SQL para obtener todas las ventas.
     *
     * ORDER BY permite mostrar los registros
     * ordenados por su identificador.
     */
    private static final String SQL_LISTAR_VENTAS =
            "SELECT id_venta, total, metodo_pago " +
                    "FROM ventas " +
                    "ORDER BY id_venta";

    /*
     * Registra una nueva venta en PostgreSQL
     * y devuelve el ID generado por la base de datos.
     */
    @Override
    public int crearVenta(Venta venta) {

        /*
         * El try-with-resources cierra automáticamente
         * la conexión y el PreparedStatement.
         */
        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(
                                SQL_CREAR_VENTA
                        )
        ) {

            /*
             * Reemplaza el primer signo ? de la consulta
             * por el total de la venta.
             */
            sentencia.setDouble(
                    1,
                    venta.getTotal()
            );

            /*
             * Reemplaza el segundo signo ? de la consulta
             * por el método de pago.
             */
            sentencia.setString(
                    2,
                    venta.getMetodoPago()
            );

            /*
             * Se utiliza executeQuery porque la consulta
             * incluye RETURNING id_venta.
             *
             * PostgreSQL devuelve un resultado con el ID
             * generado automáticamente.
             */
            try (
                    ResultSet resultado =
                            sentencia.executeQuery()
            ) {

                /*
                 * resultado.next() mueve el cursor
                 * hacia la primera fila devuelta.
                 */
                if (resultado.next()) {

                    /*
                     * Devuelve el ID generado
                     * por PostgreSQL.
                     */
                    return resultado.getInt(
                            "id_venta"
                    );
                }
            }

            /*
             * Esta excepción se ejecutaría si PostgreSQL
             * guarda la venta, pero no devuelve ningún ID.
             */
            throw new RuntimeException(
                    "No se pudo obtener el ID de la venta"
            );

        } catch (SQLException e) {

            /*
             * Convierte el error técnico de PostgreSQL
             * en una excepción del programa.
             */
            throw new RuntimeException(
                    "Error al registrar la venta",
                    e
            );
        }
    }

    /*
     * Busca una venta mediante su identificador.
     */
    @Override
    public Venta buscarVenta(int id) {

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(
                                SQL_BUSCAR_VENTA
                        )
        ) {

            /*
             * Reemplaza el signo ? de la consulta
             * por el ID recibido.
             */
            sentencia.setInt(
                    1,
                    id
            );

            /*
             * Ejecuta el SELECT y recibe
             * las filas encontradas.
             */
            try (
                    ResultSet resultado =
                            sentencia.executeQuery()
            ) {

                /*
                 * Se utiliza if porque se espera
                 * encontrar como máximo una venta.
                 */
                if (resultado.next()) {

                    /*
                     * Convierte la fila de PostgreSQL
                     * en un objeto Venta de Java.
                     */
                    return new Venta(
                            resultado.getInt(
                                    "id_venta"
                            ),
                            resultado.getDouble(
                                    "total"
                            ),
                            resultado.getString(
                                    "metodo_pago"
                            )
                    );
                }
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al buscar la venta",
                    e
            );
        }

        /*
         * Si no se encontró ninguna fila,
         * el método devuelve null.
         */
        return null;
    }

    /*
     * Actualiza una venta existente.
     */
    @Override
    public void actualizarVenta(Venta venta) {

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(
                                SQL_ACTUALIZAR_VENTA
                        )
        ) {

            /*
             * Primer signo ?: nuevo total.
             */
            sentencia.setDouble(
                    1,
                    venta.getTotal()
            );

            /*
             * Segundo signo ?: nuevo método de pago.
             */
            sentencia.setString(
                    2,
                    venta.getMetodoPago()
            );

            /*
             * Tercer signo ?: ID de la venta
             * que se desea actualizar.
             */
            sentencia.setInt(
                    3,
                    venta.getIdVenta()
            );

            /*
             * Ejecuta la actualización.
             */
            sentencia.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al actualizar la venta",
                    e
            );
        }
    }

    /*
     * Obtiene todas las ventas registradas
     * en la base de datos.
     */
    @Override
    public List<Venta> listarVentas() {

        /*
         * Se crea inicialmente una lista vacía.
         */
        List<Venta> ventas =
                new ArrayList<>();

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(
                                SQL_LISTAR_VENTAS
                        );

                ResultSet resultado =
                        sentencia.executeQuery()
        ) {

            /*
             * Se utiliza while porque la consulta
             * puede devolver varias ventas.
             */
            while (resultado.next()) {

                /*
                 * Convierte la fila actual de PostgreSQL
                 * en un objeto Venta.
                 */
                Venta venta = new Venta(
                        resultado.getInt(
                                "id_venta"
                        ),
                        resultado.getDouble(
                                "total"
                        ),
                        resultado.getString(
                                "metodo_pago"
                        )
                );

                /*
                 * Agrega la venta a la lista.
                 */
                ventas.add(venta);
            }

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al listar las ventas",
                    e
            );
        }

        /*
         * Devuelve todas las ventas encontradas.
         *
         * Si no hay registros, devuelve una
         * lista vacía y no null.
         */
        return ventas;
    }
}