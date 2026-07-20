package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Comprobante;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

public class ComprobanteDAO implements IComprobanteDAO {

    private static final String SQL_GUARDAR =
            "INSERT INTO comprobantes " +
                    "(id_venta, tipo, serie, numero, nombre_cliente, " +
                    "documento_cliente, subtotal, igv, total, fecha_emision) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_BUSCAR_POR_ID =
            "SELECT id_comprobante, id_venta, tipo, serie, numero, " +
                    "nombre_cliente, documento_cliente, subtotal, igv, total, fecha_emision " +
                    "FROM comprobantes " +
                    "WHERE id_comprobante = ?";

    private static final String SQL_BUSCAR_POR_ID_VENTA =
            "SELECT id_comprobante, id_venta, tipo, serie, numero, " +
                    "nombre_cliente, documento_cliente, subtotal, igv, total, fecha_emision " +
                    "FROM comprobantes " +
                    "WHERE id_venta = ?";

    private static final String SQL_LISTAR =
            "SELECT id_comprobante, id_venta, tipo, serie, numero, " +
                    "nombre_cliente, documento_cliente, subtotal, igv, total, fecha_emision " +
                    "FROM comprobantes " +
                    "ORDER BY id_comprobante";

    @Override
    public void guardar(Comprobante comprobante) {

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(
                                SQL_GUARDAR
                        )
        ) {

            sentencia.setInt(1, comprobante.getIdVenta());
            sentencia.setString(2, comprobante.getTipo());
            sentencia.setString(3, comprobante.getSerie());
            sentencia.setString(4, comprobante.getNumero());
            sentencia.setString(5, comprobante.getNombreCliente());
            sentencia.setString(6, comprobante.getDocumentoCliente());
            sentencia.setDouble(7, comprobante.getSubtotal());
            sentencia.setDouble(8, comprobante.getIgv());
            sentencia.setDouble(9, comprobante.getTotal());

            sentencia.setTimestamp(
                    10,
                    Timestamp.valueOf(
                            comprobante.getFechaEmision()
                    )
            );

            sentencia.executeUpdate();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al guardar el comprobante",
                    e
            );
        }
    }

    @Override
    public Comprobante buscarPorId(int idComprobante) {

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(
                                SQL_BUSCAR_POR_ID
                        )
        ) {

            sentencia.setInt(
                    1,
                    idComprobante
            );

            ResultSet resultado =
                    sentencia.executeQuery();

            if (resultado.next()) {

                int id =
                        resultado.getInt("id_comprobante");

                int idVenta =
                        resultado.getInt("id_venta");

                String tipo =
                        resultado.getString("tipo");

                String serie =
                        resultado.getString("serie");

                String numero =
                        resultado.getString("numero");

                String nombreCliente =
                        resultado.getString("nombre_cliente");

                String documentoCliente =
                        resultado.getString("documento_cliente");

                double subtotal =
                        resultado.getDouble("subtotal");

                double igv =
                        resultado.getDouble("igv");

                double total =
                        resultado.getDouble("total");

                LocalDateTime fechaEmision =
                        resultado
                                .getTimestamp("fecha_emision")
                                .toLocalDateTime();

                Comprobante comprobante =
                        new Comprobante(
                                id,
                                idVenta,
                                tipo,
                                serie,
                                numero,
                                nombreCliente,
                                documentoCliente,
                                subtotal,
                                igv,
                                total,
                                fechaEmision
                        );

                return comprobante;
            }

            return null;

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al buscar comprobante.",
                    e
            );
        }
    }

    @Override
    public Comprobante buscarPorIdVenta(int idVenta) {

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(
                                SQL_BUSCAR_POR_ID_VENTA
                        )
        ) {

            sentencia.setInt(
                    1,
                    idVenta
            );

            ResultSet resultado =
                    sentencia.executeQuery();

            if (resultado.next()) {

                int idComprobante =
                        resultado.getInt("id_comprobante");

                int idVentaEncontrada =
                        resultado.getInt("id_venta");

                String tipo =
                        resultado.getString("tipo");

                String serie =
                        resultado.getString("serie");

                String numero =
                        resultado.getString("numero");

                String nombreCliente =
                        resultado.getString("nombre_cliente");

                String documentoCliente =
                        resultado.getString("documento_cliente");

                double subtotal =
                        resultado.getDouble("subtotal");

                double igv =
                        resultado.getDouble("igv");

                double total =
                        resultado.getDouble("total");

                LocalDateTime fechaEmision =
                        resultado
                                .getTimestamp("fecha_emision")
                                .toLocalDateTime();

                Comprobante comprobante =
                        new Comprobante(
                                idComprobante,
                                idVentaEncontrada,
                                tipo,
                                serie,
                                numero,
                                nombreCliente,
                                documentoCliente,
                                subtotal,
                                igv,
                                total,
                                fechaEmision
                        );

                return comprobante;
            }

            return null;

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al buscar comprobante por ID de venta.",
                    e
            );
        }
    }

    @Override
    public List<Comprobante> listar() {

        List<Comprobante> comprobantes =
                new ArrayList<>();

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(
                                SQL_LISTAR
                        )
        ) {

            ResultSet resultado =
                    sentencia.executeQuery();

            while (resultado.next()) {

                int idComprobante =
                        resultado.getInt("id_comprobante");

                int idVenta =
                        resultado.getInt("id_venta");

                String tipo =
                        resultado.getString("tipo");

                String serie =
                        resultado.getString("serie");

                String numero =
                        resultado.getString("numero");

                String nombreCliente =
                        resultado.getString("nombre_cliente");

                String documentoCliente =
                        resultado.getString("documento_cliente");

                double subtotal =
                        resultado.getDouble("subtotal");

                double igv =
                        resultado.getDouble("igv");

                double total =
                        resultado.getDouble("total");

                LocalDateTime fechaEmision =
                        resultado
                                .getTimestamp("fecha_emision")
                                .toLocalDateTime();

                Comprobante comprobante =
                        new Comprobante(
                                idComprobante,
                                idVenta,
                                tipo,
                                serie,
                                numero,
                                nombreCliente,
                                documentoCliente,
                                subtotal,
                                igv,
                                total,
                                fechaEmision
                        );

                comprobantes.add(comprobante);
            }

            return comprobantes;

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Error al listar los comprobantes.",
                    e
            );
        }
    }
}