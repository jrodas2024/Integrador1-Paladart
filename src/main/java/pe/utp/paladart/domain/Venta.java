package pe.utp.paladart.domain;

/*
 * Entidad que representa una venta realizada
 * en el sistema Paladart.
 */
public class Venta {

    // Identificador único de la venta
    private int idVenta;

    // Monto total de la venta
    private double total;

    // Método de pago utilizado
    // (Efectivo, Tarjeta, Yape, etc.)
    private String metodoPago;

    /*
     * Constructor que permite crear una venta con sus datos principales.*/

    public Venta(int idVenta, double total, String metodoPago) {
        this.idVenta = idVenta;
        this.total = total;
        this.metodoPago = metodoPago;
    }

    // Obtiene el identificador de la venta
    public int getIdVenta() {
        return idVenta;
    }

    // Obtiene el monto total de la venta
    public double getTotal() {
        return total;
    }

    // Obtiene el método de pago utilizado
    public String getMetodoPago() {
        return metodoPago;
    }
}