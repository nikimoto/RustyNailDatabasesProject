namespace RustyNail.Modules
{
    using System;
    using System.Collections.Generic;
    using System.Xml.Linq;

    public class DatabaseToXmlWriter
    {
        public void GenerateSalesReportByVendor(Dictionary<string, Dictionary<DateTime, Decimal>> reports, string outputPath)
        {
            var sales = GetSales(reports);
            var allSales = new XElement("sales", sales);

            allSales.Save(outputPath);        
        }

        private List<XElement> GetSales(Dictionary<string, Dictionary<DateTime, Decimal>> reports)
        {
            var sales = new List<XElement>();
            foreach (var report in reports)
            {
                var summaries = GetSummaries(report.Value);
                var sale = new XElement("sale", summaries);
                sale.SetAttributeValue("vendor", report.Key);
                sales.Add(sale);
            }

            return sales;
        }

        private List<XElement> GetSummaries(Dictionary<DateTime, Decimal> report)
        {
            var summaries = new List<XElement>();
            foreach (var item in report)
            {   
                var elementAsString = String.Format(@"<summary date=""{0}"" total-sum=""{1:.00}"" />",
                    item.Key.ToShortDateString(), item.Value);
                var summary = XElement.Parse(elementAsString);
                summaries.Add(summary);
            }

            return summaries;
        }
    }
}
