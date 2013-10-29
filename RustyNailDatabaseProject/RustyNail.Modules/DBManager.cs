namespace RustyNail.Modules
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using RustyNail;
    using System.Data.SQLite;
    using System.Globalization;
    using RustyNail.Modules.MongoManager;
    using RustyNail.Data;

    public static class DBManager
    {
        static SupermarketEntities db = new SupermarketEntities();
        static SQLiteConnection vendorCon = new SQLiteConnection(
        @"Data Source=|DataDirectory|\..\..\..\Vendors.db; Version=3;");

        public static Dictionary<string, int> LoadTaxes()
        {
            vendorCon.Open();
            SQLiteCommand cmd = new SQLiteCommand();
            cmd.Connection = vendorCon;
            cmd.CommandText = @"SELECT * FROM ProductsTaxes";
            SQLiteDataReader reader = cmd.ExecuteReader();
            Dictionary<string, int> taxes = new Dictionary<string, int>();
            while (reader.Read())
            {
                string productName = (string)reader[1];
                string taxString = Convert.ToString(reader[2]);
                int tax = int.Parse(taxString);
                taxes.Add(productName, tax);
            }

            return taxes;
        }

        public class VendorEntry
        {
            public int Id { get; set; }

            public string Name { get; set; }

            public string Month { get; set; }

            public decimal Expenses { get; set; }
        }

        public static List<VendorEntry> RetrieveVendorExpenses()
        {
            List<VendorEntry> expenses = new List<VendorEntry>();
            foreach (var item in db.VendorExpenses.Include("Vendor"))
            {
                expenses.Add(new VendorEntry()
                {
                    Id = item.Id,
                    Name = item.Vendor.VendorName,
                    Month = item.Month.ToString(),
                    Expenses = item.Expenses
                });
            }

            return expenses;
        }

        public static List<StoreReport> RetrieveReports()
        {
            List<StoreReport> reports = new List<StoreReport>();

            DateTime currentDay = DateTime.Now;
            Decimal totalSum = 0;
            Int32 prevReportId = -1;

            foreach (var item in db.SalesReports)
            {
                if (item.ReportId != prevReportId)
                {
                    reports.Add(new StoreReport() { Date = item.DailyReport.Day });
                }

                Int32 productId = item.ProductId;
                Double quantity = item.Quantity;
                Decimal price = item.UnitPrice;
                Decimal sum = item.Sum;

                Product curProduct = db.Products.First(x => x.Id == productId);
                String productName = curProduct.ProductName;
                String measureName = db.Measures.First(
                    x => x.Id == curProduct.MeasureId).MeasureName;
                String measure = quantity + " " + measureName;
                String marketName = db.DailyReports.First(
                    x => x.Id == item.ReportId).Supermarket.SupermarketName;
                Entry entry = new Entry()
                {
                    ProductName = productName,
                    Quantity = measure,
                    UnitPrice = item.UnitPrice,
                    Location = marketName,
                    Sum = sum,
                };

                reports[reports.Count - 1].Products.Add(entry);
                reports[reports.Count - 1].TotalSum += entry.Sum;

                prevReportId = item.ReportId;
            }

            return reports;
        }

        public static Dictionary<string, Dictionary<DateTime, Decimal>> RetrieveReportByVendors()
        {
            Dictionary<string, Dictionary<DateTime, Decimal>> dailyByVendor = new Dictionary<string, Dictionary<DateTime, decimal>>();
            foreach (var item in db.SalesReports.Include("DailyReport"))
            {
                Decimal sum = item.Sum;
                DateTime day = item.DailyReport.Day;
                Int32 productId = item.ProductId;
                Int32 vendorId = db.Products.First(x => x.Id == productId).VendorId;
                String vendorName = db.Vendors.First(x => x.Id == vendorId).VendorName;
                if (dailyByVendor.ContainsKey(vendorName) == false)
                {
                    dailyByVendor.Add(vendorName, new Dictionary<DateTime, decimal>());
                }
                if (dailyByVendor[vendorName].ContainsKey(day) == false)
                {
                    dailyByVendor[vendorName].Add(day, 0);
                }
                dailyByVendor[vendorName][day] += sum;
            }
            return dailyByVendor;
        }

        public class MongoEntry
        {
            public string ProductName { get; set; }

            public string VendorName { get; set; }

            public double QuantitySold { get; set; }

            public decimal TotatIncome { get; set; }
        }

        class DateCompare : IEqualityComparer<DateTime>
        {
            public bool Equals(DateTime x, DateTime y)
            {
                bool result = x.Month == y.Month && x.Year == y.Year;
                return result;
            }

            public int GetHashCode(DateTime obj)
            {
                return obj.GetHashCode();
            }
        }

        public static Dictionary<DateTime, Dictionary<int, MongoEntry>> RetrieveProductReport()
        {
            Dictionary<DateTime, Dictionary<int, MongoEntry>> entries =
                new Dictionary<DateTime, Dictionary<int, MongoEntry>>(new DateCompare());

            foreach (var item in db.SalesReports.Include("DailyReport"))
            {
                DateTime curMonth = new DateTime(item.DailyReport.Day.Year, item.DailyReport.Day.Month, 1);
                if (entries.ContainsKey(curMonth) == false)
                {
                    entries.Add(curMonth, new Dictionary<int, MongoEntry>());
                }

                if (entries[curMonth].ContainsKey(item.ProductId) == false)
                {
                    entries[curMonth].Add(item.ProductId, new MongoEntry()
                    {
                        QuantitySold = item.Quantity,
                        TotatIncome = item.Sum,
                    });
                    Product curProduct = db.Products.FirstOrDefault(
                        x => x.Id == item.ProductId);
                    entries[curMonth][item.ProductId].ProductName = curProduct.ProductName;
                    int vendorId = curProduct.VendorId;
                    string vendorName = db.Vendors.FirstOrDefault(
                        x => x.Id == vendorId).VendorName;
                    entries[curMonth][item.ProductId].VendorName = vendorName;
                }
                entries[curMonth][item.ProductId].QuantitySold += item.Quantity;
                entries[curMonth][item.ProductId].TotatIncome += item.Sum;
            }
            return entries;
        }

        public class ProductTotalReport
        {
            public decimal Incomes { get; set; }

            public decimal Expenses { get; set; }

            public decimal Taxes { get; set; }

            public decimal FinancalResult { get; set; }
        }

        public static Dictionary<string, ProductTotalReport> RetrieveTotalReport(DateTime wantedMonth)
        {
            Dictionary<string, ProductTotalReport> monthReport = new Dictionary<string, ProductTotalReport>();
            Dictionary<string, int> taxesPercent = LoadTaxes();
            wantedMonth = new DateTime(wantedMonth.Year, wantedMonth.Month, 1);
            var allReports = Manager.RetrieveTotalReport();

            foreach (var curMonthReport in allReports)
            {
                if (curMonthReport.Key.Month != wantedMonth.Month && curMonthReport.Key.Year != wantedMonth.Year)
                {
                    continue;
                }
                foreach (var item in curMonthReport.Value)
                {
                    if (monthReport.ContainsKey(item.Value.VendorName) == false)
                    {
                        monthReport.Add(item.Value.VendorName, new ProductTotalReport());
                    }
                    monthReport[item.Value.VendorName].Incomes += item.Value.TotatIncome;
                    monthReport[item.Value.VendorName].Taxes += item.Value.TotatIncome * (taxesPercent[item.Value.ProductName] * 0.01M);
                }
            }

            foreach (var item in monthReport)
            {
                if (db.VendorExpenses.Where(x => x.Vendor.VendorName == item.Key).Any() == false)
                {
                    monthReport[item.Key].Expenses = 0;
                }
                else
                {
                    monthReport[item.Key].Expenses = db.VendorExpenses.FirstOrDefault(x => x.Vendor.VendorName == item.Key).Expenses;
                }
                monthReport[item.Key].FinancalResult = monthReport[item.Key].Incomes -
                                                       monthReport[item.Key].Taxes -
                                                       monthReport[item.Key].Expenses;
            }

            return monthReport;
        }

        public static void InsertVendorExpenses(Dictionary<string, Dictionary<DateTime, Decimal>> expenses)
        {
            foreach (var item in expenses)
            {
                Int32 vendorId = db.Vendors.FirstOrDefault(x => x.VendorName == item.Key).Id;
                foreach (var day in item.Value)
                {
                    if (db.VendorExpenses.Where(x => x.Month == day.Key && x.VendorId == vendorId).Any())
                    {
                        continue;
                    }
                    db.VendorExpenses.Add(new VendorExpens()
                    {
                        VendorId = vendorId,
                        Month = day.Key,
                        Expenses = day.Value
                    });
                }
            }
            db.SaveChanges();
        }

        public static void InsertSalesReports(StoreReport report)
        {
            String marketName = report.MarketName;
            int marketId = -1;

            if (!db.Supermarkets.Where(s => s.SupermarketName == marketName).Any())
            {
                var market = new Supermarket() { SupermarketName = marketName };
                db.Supermarkets.Add(market);
                db.SaveChanges();
                marketId = market.Id;
            }
            else
            {
                marketId = db.Supermarkets.First(s => s.SupermarketName == marketName).Id;
            }

            if (db.DailyReports.Where(x => x.Day == report.Date &&
                x.SuperMarketId == marketId).Any())
            {
                return;
            }

            var daily = new DailyReport() { Day = report.Date, SuperMarketId = marketId };
            db.DailyReports.Add(daily);
            db.SaveChanges();

            var reportId = daily.Id;
            ProductsData.ProductsModel mysqlModel = new ProductsData.ProductsModel();

            foreach (var product in report.Products)
            {
                var prodId = db.Products.First(p => p.OldId == product.ProductId).Id;

                db.SalesReports.Add(new SalesReport()
                {
                    ReportId = reportId,
                    ProductId = prodId,
                    Quantity = product.QuantityValue,
                    UnitPrice = product.UnitPrice,
                    Sum = product.Sum
                });
            }

            db.SaveChanges();
        }

        public static IQueryable<SalesReport> GetMonthlyProducts()
        {
            var monthlyReports = db.SalesReports.Where(s => s.DailyReport.Day.Month == DateTime.Now.Month &&
                s.DailyReport.Day.Year == DateTime.Now.Year);

            return monthlyReports;
        }
    }
}