namespace RustyNail.Main
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using RustyNail.Data;
    using RustyNail.Modules;
    using RustyNail.Modules.MongoManager;

    public class RustyNailMain
    {
        const string path = @"../../";

        static void Main()
        {
            InitModules.PopulateProducts();

            Console.WriteLine("Parsing excel reports...");
            var excelReports = ExcelParser.ParseExcel(path);

            Console.WriteLine("Inserting sales reports...");

            foreach (var report in excelReports)
            {
                DBManager.InsertSalesReports(report);
            }

            Console.WriteLine("Generating pdf aggregated sales report.");
            DatabaseToPdfWriter pdfWriter = new DatabaseToPdfWriter();
            var reports = DBManager.RetrieveReports();
            pdfWriter.GeneratePDFAggregatedSalesReports(reports, "..\\..\\Report.pdf");

            Console.WriteLine("Generating sales by vendor XML file...");
            DatabaseToXmlWriter xmlWriter = new DatabaseToXmlWriter();
            xmlWriter.GenerateSalesReportByVendor(DBManager.RetrieveReportByVendors(), "..\\..\\Sales-by-Vendors-report.xml");
            XmlParser xmlParser = new XmlParser();
            DBManager.InsertVendorExpenses(xmlParser.ParseFile("..\\..\\Vendors-Expenses.xml"));

            Console.WriteLine("Inserting data in MongoDb...");
            Manager mongoManager = new Manager("mongodb://localhost");
            mongoManager.AddProducts(DBManager.GetMonthlyProducts());

            Console.WriteLine("Generating .xls file...");
            DBManager.RetrieveProductReport();
            DatabaseToExcelWriter.CreateExcelTable(DBManager.RetrieveTotalReport(DateTime.Now));
        }
    }
}
