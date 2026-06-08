package pe.utp.paladart.business;

import org.junit.jupiter.api.Test;
import pe.utp.paladart.domain.Venta;
import pe.utp.paladart.persistence.IVentaDAO;
import pe.utp.paladart.persistence.VentaDAOMock;

import static org.junit.jupiter.api.Assertions.assertThrows;

/**
 * Pruebas unitarias para la clase VentaService.
 * Permiten validar las reglas de negocio utilizando JUnit.
 */
public class VentaServiceTest {

    /**
     * Verifica que no se permita registrar una venta
     * cuando el método de pago está vacío.
     */
    @Test
    void validarMetodoPagoObligatorio() {

        // Implementación simulada del DAO
        IVentaDAO dao = new VentaDAOMock();

        // Servicio que contiene las reglas de negocio
        VentaService service = new VentaService(dao);

        // Venta inválida: método de pago vacío
        Venta venta = new Venta(
                1,
                100.0,
                ""
        );

        // Se espera una excepción porque el método de pago es obligatorio
        assertThrows(
                IllegalArgumentException.class,
                () -> service.registrarVenta(venta),
                "No se debe permitir registrar ventas sin método de pago"
        );
    }

    /**
     * Verifica que no se permita registrar una venta
     * cuando el total es menor o igual a cero.
     */
    @Test
    void validarTotalMayorACero() {

        // Implementación simulada del DAO
        IVentaDAO dao = new VentaDAOMock();

        // Servicio que contiene las reglas de negocio
        VentaService service = new VentaService(dao);

        // Venta inválida: total negativo
        Venta venta = new Venta(
                2,
                -20.0,
                "Efectivo"
        );

        // Se espera una excepción porque el total debe ser mayor a cero
        assertThrows(
                IllegalArgumentException.class,
                () -> service.registrarVenta(venta),
                "No se debe permitir registrar ventas con total negativo"
        );
    }

    /**
     * Verifica que no se permita registrar una venta
     * cuando el ID de la venta es menor o igual a cero.
     */
    @Test
    void validarIdVentaMayorACero() {

        // Implementación simulada del DAO
        IVentaDAO dao = new VentaDAOMock();

        // Servicio que contiene las reglas de negocio
        VentaService service = new VentaService(dao);

        // Venta inválida: ID negativo
        Venta venta = new Venta(
                -1,
                100.0,
                "Efectivo"
        );

        // Se espera una excepción porque el ID debe ser mayor a cero
        assertThrows(
                IllegalArgumentException.class,
                () -> service.registrarVenta(venta),
                "No se debe permitir registrar ventas con ID menor o igual a cero"
        );
    }
}