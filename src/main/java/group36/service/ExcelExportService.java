package group36.service;

import group36.model.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

public class ExcelExportService {

    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    private static final SimpleDateFormat EXPIRY_FORMAT = new SimpleDateFormat("dd/MM/yyyy");

    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.WHITE.getIndex());
        font.setFontHeightInPoints((short) 11);
        style.setFont(font);
        
        style.setFillForegroundColor(IndexedColors.DARK_GREEN.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        
        setCellBorders(style);
        return style;
    }

    private CellStyle createDataStyle(Workbook workbook, HorizontalAlignment align) {
        CellStyle style = workbook.createCellStyle();
        style.setAlignment(align);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        setCellBorders(style);
        return style;
    }

    private CellStyle createCurrencyStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        DataFormat format = workbook.createDataFormat();
        style.setDataFormat(format.getFormat("#,##0\"đ\""));
        style.setAlignment(HorizontalAlignment.RIGHT);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        setCellBorders(style);
        return style;
    }

    private void setCellBorders(CellStyle style) {
        style.setBorderBottom(BorderStyle.THIN);
        style.setBottomBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setBorderTop(BorderStyle.THIN);
        style.setTopBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setBorderLeft(BorderStyle.THIN);
        style.setLeftBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setBorderRight(BorderStyle.THIN);
        style.setRightBorderColor(IndexedColors.GREY_25_PERCENT.getIndex());
    }

    private String formatTimestamp(Timestamp ts, SimpleDateFormat sdf) {
        if (ts == null) return "";
        return sdf.format(ts);
    }

    public void exportProducts(List<Product> products, OutputStream out) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Danh sách sản phẩm");

            Row headerRow = sheet.createRow(0);
            headerRow.setHeightInPoints(28);
            CellStyle headerStyle = createHeaderStyle(workbook);

            String[] headers = {
                "ID Sản phẩm", "Tên sản phẩm", "Danh mục", "Đã bán", "Đánh giá",
                "Biến thể/Loại", "Giá bán", "Giá nhập", "Số lượng tồn", "Ngày hết hạn"
            };

            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            CellStyle leftStyle = createDataStyle(workbook, HorizontalAlignment.LEFT);
            CellStyle centerStyle = createDataStyle(workbook, HorizontalAlignment.CENTER);
            CellStyle currencyStyle = createCurrencyStyle(workbook);

            int rowIdx = 1;
            for (Product p : products) {
                List<ProductVariant> variants = p.getVariants();
                if (variants == null || variants.isEmpty()) {
                    Row row = sheet.createRow(rowIdx++);
                    row.setHeightInPoints(20);

                    createCell(row, 0, p.getId(), centerStyle);
                    createCell(row, 1, p.getName(), leftStyle);
                    createCell(row, 2, p.getCategory() != null ? p.getCategory().getName() : "", leftStyle);
                    createCell(row, 3, p.getSoldCount(), centerStyle);
                    createCell(row, 4, p.getAvgRating(), centerStyle);
                    createCell(row, 5, "N/A", centerStyle);
                    createCell(row, 6, 0.0, currencyStyle);
                    createCell(row, 7, 0.0, currencyStyle);
                    createCell(row, 8, 0, centerStyle);
                    createCell(row, 9, "", centerStyle);
                } else {
                    for (ProductVariant v : variants) {
                        Row row = sheet.createRow(rowIdx++);
                        row.setHeightInPoints(20);

                        createCell(row, 0, p.getId(), centerStyle);
                        createCell(row, 1, p.getName(), leftStyle);
                        createCell(row, 2, p.getCategory() != null ? p.getCategory().getName() : "", leftStyle);
                        createCell(row, 3, p.getSoldCount(), centerStyle);
                        createCell(row, 4, p.getAvgRating(), centerStyle);
                        createCell(row, 5, v.getOptionsValue(), leftStyle);
                        createCell(row, 6, v.getPrice(), currencyStyle);
                        createCell(row, 7, v.getImportPrice(), currencyStyle);
                        createCell(row, 8, v.getStock(), centerStyle);
                        createCell(row, 9, formatTimestamp(v.getExpiryDate(), EXPIRY_FORMAT), centerStyle);
                    }
                }
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
        }
    }


    private void createCell(Row row, int colIdx, String value, CellStyle style) {
        Cell cell = row.createCell(colIdx);
        cell.setCellValue(value != null ? value : "");
        cell.setCellStyle(style);
    }

    private void createCell(Row row, int colIdx, double value, CellStyle style) {
        Cell cell = row.createCell(colIdx);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }

    private void createCell(Row row, int colIdx, int value, CellStyle style) {
        Cell cell = row.createCell(colIdx);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }
}
