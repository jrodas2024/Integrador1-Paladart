package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Comprobante;

import java.util.ArrayList;
import java.util.List;

public class ComprobanteDAOMock implements IComprobanteDAO {

    // static permite conservar temporalmente los comprobantes emitidos durante la ejecución del sistema.
    private static final List<Comprobante> comprobantes =
            new ArrayList<>();

    @Override
    public void guardar(Comprobante comprobante) {
        comprobantes.add(comprobante);
    }

    @Override
    public Comprobante buscarPorId(int idComprobante) {
        return comprobantes.stream()
                .filter(comprobante ->
                        comprobante.getIdComprobante() == idComprobante)
                .findFirst()
                .orElse(null);
    }

    @Override
    public Comprobante buscarPorIdVenta(int idVenta) {
        return comprobantes.stream()
                .filter(comprobante ->
                        comprobante.getIdVenta() == idVenta)
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<Comprobante> listar() {
        return new ArrayList<>(comprobantes);
    }
}