package pe.utp.paladart.util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import pe.utp.paladart.domain.Venta;

import java.io.FileOutputStream;
import java.util.List;

public class ExportadorExcel {

    public void generarReporte(List<Venta> ventas) {

        try (Workbook workbook = new XSSFWorkbook()) {

            Sheet hoja = workbook.createSheet("Reporte Ventas");

            // Estilo del encabezado
            CellStyle estiloEncabezado = workbook.createCellStyle();
            Font fuenteEncabezado = workbook.createFont();
            fuenteEncabezado.setBold(true);
            fuenteEncabezado.setColor(IndexedColors.WHITE.getIndex());

            estiloEncabezado.setFont(fuenteEncabezado);
            estiloEncabezado.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
            estiloEncabezado.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            estiloEncabezado.setAlignment(HorizontalAlignment.CENTER);
            estiloEncabezado.setBorderBottom(BorderStyle.THIN);
            estiloEncabezado.setBorderTop(BorderStyle.THIN);
            estiloEncabezado.setBorderLeft(BorderStyle.THIN);
            estiloEncabezado.setBorderRight(BorderStyle.THIN);

            // Estilo de datos
            CellStyle estiloDatos = workbook.createCellStyle();
            estiloDatos.setBorderBottom(BorderStyle.THIN);
            estiloDatos.setBorderTop(BorderStyle.THIN);
            estiloDatos.setBorderLeft(BorderStyle.THIN);
            estiloDatos.setBorderRight(BorderStyle.THIN);

            // Encabezados
            Row encabezado = hoja.createRow(0);
            String[] columnas = {"ID Venta", "Total", "Método de Pago"};

            for (int i = 0; i < columnas.length; i++) {
                Cell celda = encabezado.createCell(i);
                celda.setCellValue(columnas[i]);
                celda.setCellStyle(estiloEncabezado);
            }

            // Datos
            int numeroFila = 1;

            for (Venta venta : ventas) {
                Row fila = hoja.createRow(numeroFila++);

                Cell celdaId = fila.createCell(0);
                celdaId.setCellValue(venta.getIdVenta());
                celdaId.setCellStyle(estiloDatos);

                Cell celdaTotal = fila.createCell(1);
                celdaTotal.setCellValue(venta.getTotal());
                celdaTotal.setCellStyle(estiloDatos);

                Cell celdaMetodo = fila.createCell(2);
                celdaMetodo.setCellValue(venta.getMetodoPago());
                celdaMetodo.setCellStyle(estiloDatos);
            }

            // Ajustar ancho de columnas
            for (int i = 0; i < columnas.length; i++) {
                hoja.autoSizeColumn(i);
            }
            hoja.setColumnWidth(0, 3500);
            hoja.setColumnWidth(1, 3500);
            hoja.setColumnWidth(2, 6000);

            try (FileOutputStream archivo = new FileOutputStream("ReporteVentas.xlsx")) {
                workbook.write(archivo);
            }

            System.out.println("Reporte Excel generado correctamente.");

        } catch (Exception e) {
            System.out.println("Error al generar Excel: " + e.getMessage());
        }
    }
}