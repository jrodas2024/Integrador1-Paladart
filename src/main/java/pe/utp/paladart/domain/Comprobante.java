package pe.utp.paladart.domain;

import java.time.LocalDateTime;

public class Comprobante {

    private int idComprobante;
    private int idVenta;
    private String tipo;
    private String serie;
    private String numero;
    private String nombreCliente;
    private String documentoCliente;
    private double subtotal;
    private double igv;
    private double total;
    private LocalDateTime fechaEmision;

    public Comprobante(
            int idComprobante,
            int idVenta,
            String tipo,
            String serie,
            String numero,
            String nombreCliente,
            String documentoCliente,
            double subtotal,
            double igv,
            double total,
            LocalDateTime fechaEmision) {

        this.idComprobante = idComprobante;
        this.idVenta = idVenta;
        this.tipo = tipo;
        this.serie = serie;
        this.numero = numero;
        this.nombreCliente = nombreCliente;
        this.documentoCliente = documentoCliente;
        this.subtotal = subtotal;
        this.igv = igv;
        this.total = total;
        this.fechaEmision = fechaEmision;
    }

    public int getIdComprobante() {
        return idComprobante;
    }

    public int getIdVenta() {
        return idVenta;
    }

    public String getTipo() {
        return tipo;
    }

    public String getSerie() {
        return serie;
    }

    public String getNumero() {
        return numero;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public String getDocumentoCliente() {
        return documentoCliente;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public double getIgv() {
        return igv;
    }

    public double getTotal() {
        return total;
    }

    public LocalDateTime getFechaEmision() {
        return fechaEmision;
    }
}