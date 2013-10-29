namespace RustyNail.Modules
{
    using RustyNail.Data;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Web.Script.Serialization;

    public class JsonHandler
    {
        public List<string> CreateJsonReports(Dictionary<DateTime, Dictionary<int, DBManager.MongoEntry>> reports)
        {
            string pathString = "../../../Product-Reports/";
            if (!Directory.Exists(pathString))
            {
                Directory.CreateDirectory(pathString);
            }
            
            var reportsAsStringsList = new List<string>();
            foreach (var report in reports)
            {   
                foreach (var entry in report.Value)
                {
                    var productReport = new ProductReport(entry.Key, entry.Value.ProductName, entry.Value.VendorName,
                        entry.Value.QuantitySold, entry.Value.TotatIncome);
                    var serializeProductReport = new JavaScriptSerializer().Serialize(productReport);
                    reportsAsStringsList.Add(serializeProductReport);

                    SaveJsonIntoFile(serializeProductReport, pathString, entry.Key);
                }
            }

            return reportsAsStringsList;
        }
  
        private void SaveJsonIntoFile(string serializeProductReport, string pathString, int id)
        {
            var trimParams = new char[] { ',', '}', '{' };
            var reportAsStringArr = serializeProductReport.Trim(trimParams)
                                                          .Split(',');
                      
            using (var streamWriter = new StreamWriter(pathString + id + ".json"))
            {
                streamWriter.WriteLine("{");
                foreach (var item in reportAsStringArr)
                {
                    var comma = ",";
                    if (item == reportAsStringArr.Last())
                    {
                        comma = "";
                    }
                    streamWriter.WriteLine(" " + item + comma);                                
                }
                streamWriter.WriteLine("}");
            }
        }

        public class ProductReport
        {
            public int ProductId { get; private set; }
            public string ProductName { get; private set; }
            public string VendorName { get; private set; }
            public double TotalQuantitySold { get; private set; }
            public decimal TotalIncomes { get; private set; }

            public ProductReport(int productId, string productName,
                string vendorName, double totalQuantityIncome, decimal totalIncomes)
            {
                this.ProductId = productId;
                this.ProductName = productName;
                this.VendorName = vendorName;
                this.TotalQuantitySold = totalQuantityIncome;
                this.TotalIncomes = totalIncomes;
            }
        }
    }
}
