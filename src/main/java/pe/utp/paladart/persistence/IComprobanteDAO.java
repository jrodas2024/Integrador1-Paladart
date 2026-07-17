package pe.utp.paladart.persistence;

import pe.utp.paladart.domain.Comprobante;

import java.util.List;

public interface IComprobanteDAO {

    void guardar(Comprobante comprobante);

    Comprobante buscarPorId(int idComprobante);
    Comprobante buscarPorIdVenta(int idVenta);

    List<Comprobante> listar();
}