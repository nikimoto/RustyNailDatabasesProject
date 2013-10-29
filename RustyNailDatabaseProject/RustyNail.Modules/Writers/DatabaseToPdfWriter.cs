namespace RustyNail.Modules
{
    using iTextSharp.text;
    using iTextSharp.text.pdf;
    using RustyNail.Data;
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    
    public class DatabaseToPdfWriter
    {
        private const int TABLE_COLUMNS = 5;
        private readonly byte[] BASE_COLOR_GRAY = { 200, 200, 200 };

        public void GeneratePDFAggregatedSalesReports(List<StoreReport> allReports, string outputPath)
        {
            string path = outputPath;
            FileStream fileStream = File.Create(path);

            Rectangle pageSize = new Rectangle(900, 700);
            Document pdf = new Document(pageSize);
            pdf.SetMargins(.1f, .1f, .1f, .1f);
            //pdf.SetMargins(0f, 0f, 0f, 0f);
            
            PdfWriter.GetInstance(pdf, fileStream);

            pdf.Open();
            var pdfTable = new PdfPTable(TABLE_COLUMNS);
            pdfTable.SetTotalWidth(new float[] { 0.5f, 0.3f, 0.2f, 1f, .3f });
            FillTable(pdfTable, allReports);
            pdf.Add(pdfTable);
            pdf.Close();
        }
  
        private void FillTable(PdfPTable pdfTable, List<StoreReport> allReports)
        {
            var mainHeaderCell = GetCustomizedCell("Aggregated Sales Report", 1, TABLE_COLUMNS, 15);
            pdfTable.AddCell(mainHeaderCell);
            mainHeaderCell.Padding = 0f;

            var currentDate = allReports.First().Date;
            SetHeadersContent(pdfTable, currentDate);
            
            decimal currentSum = 0;
            decimal grandTotalSum = 0;
            var isDateChanged = false;
            foreach (var monthReport in allReports)
            {
                if (isDateChanged)//monthReport.Date != currentDate)
                {
                    SetHeadersContent(pdfTable, monthReport.Date);
                    isDateChanged = false;
                }

                foreach (var product in monthReport.Products)
                {
                    AddProductInfo(product, pdfTable);
                }

                currentSum += monthReport.TotalSum;
                grandTotalSum += monthReport.TotalSum;

                if (!monthReport.Date.Equals(currentDate))// || monthReport.Equals(allReports.First()))
                {
                    SetTotalSumRow(pdfTable, currentSum, monthReport);
                    currentDate = monthReport.Date;
                    currentSum = 0;
                    isDateChanged = true;
                }
            }

            SetTotalSumRow(pdfTable, currentSum, allReports.Last());
            SetGrandTotalSumRow(pdfTable, grandTotalSum);
        }
  
        private void AddProductInfo(Entry product, PdfPTable pdfTable)
        {
            pdfTable.AddCell(product.ProductName);
            pdfTable.AddCell(product.Quantity);
            pdfTable.AddCell(String.Format("{0:F2}", product.UnitPrice));
            pdfTable.AddCell(product.Location);
            pdfTable.AddCell(String.Format("{0:F2}", product.Sum));
        }

        private void SetTotalSumRow(PdfPTable pdfTable, decimal currentSum, StoreReport monthReport)
        {
            var monthAsString = new DateTimeFormatInfo().GetMonthName(monthReport.Date.Month);
            var dateString = monthReport.Date.Day + "-" + monthAsString + "-" + monthReport.Date.Year;
            var sumHeaderCell = GetCustomizedCell("Total sum for " + dateString, 2, 4, 6);
            var totalSumCell = GetCustomizedCell(String.Format("{0:F2}", currentSum), 2, 1, 6);
            pdfTable.AddCell(sumHeaderCell);
            pdfTable.AddCell(totalSumCell);
        }

        private void SetGrandTotalSumRow(PdfPTable pdfTable, decimal grandTotalSum)
        {
            var sumHeaderCell = GetCustomizedCell("Grand total: ", 2, 4, 6);
            var totalSumCell = GetCustomizedCell(String.Format("{0:F2}", grandTotalSum), 2, 1, 6);
            pdfTable.AddCell(sumHeaderCell);
            pdfTable.AddCell(totalSumCell);
        }

        public void SetHeadersContent(PdfPTable pdfTable, DateTime date)
        {
            var monthAsString = new DateTimeFormatInfo().GetMonthName(date.Month);
            var dateString = date.Day + "-" + monthAsString + "-" + date.Year;
            var dateHeaderCell = GetCustomizedCell("Date: " + dateString, 0, TABLE_COLUMNS, 10,
                BASE_COLOR_GRAY[0], BASE_COLOR_GRAY[1], BASE_COLOR_GRAY[2]);
            pdfTable.AddCell(dateHeaderCell);

            var headerCellsNames = new string[5] { "Product", "Quantity", "Unit Price", "Location", "Sum"};
            
            for (int i = 0; i < headerCellsNames.Length; i++)
			{
                var cell = GetCustomizedCell(headerCellsNames[i], 0, 0, 8, BASE_COLOR_GRAY[0], BASE_COLOR_GRAY[0], BASE_COLOR_GRAY[0]);
                pdfTable.AddCell(cell);
			}
        }

        public PdfPCell GetCustomizedCell(string content, int alignment, int colspan = TABLE_COLUMNS, int padding = 10, 
            int red = 255, int green = 255, int blue = 255)
        {
            var cellContent = new Phrase(content);
            var cell = new PdfPCell(cellContent);
            
            cell.Colspan = colspan;
            cell.HorizontalAlignment = alignment;
            cell.Padding = padding;
            cell.BackgroundColor = new BaseColor(red, green, blue);
            
            
            return cell;
        }
    }
}
