package pe.utp.paladart.controller;

import pe.utp.paladart.business.VentaService;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.view.VentaView;

public class VentaController {

    private final VentaService ventaService;
    private final VentaView ventaView;

    public VentaController(VentaService ventaService,
                           VentaView ventaView) {
        this.ventaService = ventaService;
        this.ventaView = ventaView;
    }

    public void registrarVenta(Venta venta) {
        ventaService.registrarVenta(venta);
        ventaView.mostrarMensaje(
                "Venta procesada correctamente."
        );
    }
}