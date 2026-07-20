package pe.utp.paladart.business;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.IVentaDAO;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.*;

/**
 * Pruebas unitarias para VentaService usando JUnit 5 y Mockito.
 */
@ExtendWith(MockitoExtension.class)
public class VentaServiceTest {

    @Mock
    private IVentaDAO ventaDAO;

    @InjectMocks
    private VentaService ventaService;

    @Test
    void debeRegistrarVentaCorrectamente() {
        Venta venta = new Venta(1, 100.0, "Efectivo");

        ventaService.registrarVenta(venta);

        verify(ventaDAO).crearVenta(venta);
    }

    @Test
    void validarMetodoPagoObligatorio() {
        Venta venta = new Venta(1, 100.0, "");

        assertThrows(
                IllegalArgumentException.class,
                () -> ventaService.registrarVenta(venta),
                "No se debe permitir registrar ventas sin método de pago"
        );

        verify(ventaDAO, never()).crearVenta(any(Venta.class));
    }

    @Test
    void validarTotalMayorACero() {
        Venta venta = new Venta(2, -20.0, "Efectivo");

        assertThrows(
                IllegalArgumentException.class,
                () -> ventaService.registrarVenta(venta),
                "No se debe permitir registrar ventas con total negativo"
        );

        verify(ventaDAO, never()).crearVenta(any(Venta.class));
    }


}