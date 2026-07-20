package pe.utp.paladart.business;

import com.google.common.base.Preconditions;
import pe.utp.paladart.domain.Comprobante;
import pe.utp.paladart.persistence.IComprobanteDAO;

import java.time.LocalDateTime;
import java.util.List;

public class ComprobanteService {

    private final IComprobanteDAO comprobanteDAO;

    public ComprobanteService(IComprobanteDAO comprobanteDAO) {
        this.comprobanteDAO = comprobanteDAO;
    }

    public Comprobante emitir(
            int idVenta,
            String tipo,
            String nombreCliente,
            String documentoCliente,
            double total
    ) {

        Preconditions.checkArgument(
                idVenta > 0,
                "El ID de la venta debe ser válido"
        );

        Preconditions.checkArgument(
                comprobanteDAO.buscarPorIdVenta(idVenta) == null,
                "La venta ya tiene un comprobante emitido"
        );

        Preconditions.checkArgument(
                tipo != null
                        && (
                        tipo.equalsIgnoreCase("BOLETA")
                                || tipo.equalsIgnoreCase("FACTURA")
                ),
                "Debe seleccionar boleta o factura"
        );

        Preconditions.checkArgument(
                total > 0,
                "El total debe ser mayor a cero"
        );

        /*
         * Limpia espacios y cualquier carácter
         * diferente de un número.
         */
        String documento =
                documentoCliente == null
                        ? ""
                        : documentoCliente.replaceAll(
                        "\\D",
                        ""
                );

        if (tipo.equalsIgnoreCase("FACTURA")) {

            Preconditions.checkArgument(
                    documento.matches("\\d{11}"),
                    "Para emitir una factura debe ingresar un RUC de 11 dígitos"
            );
        }

        if (
                tipo.equalsIgnoreCase("BOLETA")
                        && !documento.isEmpty()
        ) {

            Preconditions.checkArgument(
                    documento.matches("\\d{8}"),
                    "El DNI debe tener 8 dígitos"
            );
        }

        int numeroSiguiente =
                comprobanteDAO.listar().size() + 1;

        String serie =
                tipo.equalsIgnoreCase("BOLETA")
                        ? "B001"
                        : "F001";

        String numero =
                String.format(
                        "%08d",
                        numeroSiguiente
                );

        double subtotal =
                redondear(total / 1.18);

        double igv =
                redondear(total - subtotal);

        Comprobante comprobante =
                new Comprobante(
                        0,
                        idVenta,
                        tipo.toUpperCase(),
                        serie,
                        numero,
                        nombreCliente == null
                                ? ""
                                : nombreCliente.trim(),
                        documento,
                        subtotal,
                        igv,
                        redondear(total),
                        LocalDateTime.now()
                );

        comprobanteDAO.guardar(comprobante);

        return comprobanteDAO.buscarPorIdVenta(
                idVenta
        );
    }

    public List<Comprobante> listar() {
        return comprobanteDAO.listar();
    }

    public Comprobante buscarPorVenta(int idVenta) {
        return comprobanteDAO.buscarPorIdVenta(idVenta);
    }

    private double redondear(double valor) {
        return Math.round(valor * 100.0) / 100.0;
    }
}

