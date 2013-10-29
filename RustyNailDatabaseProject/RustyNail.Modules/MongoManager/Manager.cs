namespace RustyNail.Modules.MongoManager
{
    using MongoDB.Driver;
    using MongoDB.Driver.Linq;
    using RustyNail.Data;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    public class Manager
    {
        private SupermarketEntities entDb = new SupermarketEntities();
        private const string dbString = "products";
        private string connectionString;
        private MongoClient client;
        private MongoServer server;
        private MongoDatabase db;
        private MongoCollection<MongoProduct> products;
        private static string defaultServer = "mongodb://localhost";

        public Manager()
            : this(defaultServer, false)
        {
        }

        public Manager(string connectionString, bool removeAll = true)
        {
            this.connectionString = connectionString;
            this.client = new MongoClient(connectionString);
            this.server = client.GetServer();
            this.db = server.GetDatabase(dbString);
            this.products = db.GetCollection<MongoProduct>(dbString);

            if (removeAll)
            {
                this.products.RemoveAll();                
            }
        }

        public void AddProducts(IQueryable<SalesReport> reports)
        {
            var productIDs = reports.Select(x => x.ProductId).Distinct();

            foreach (var productId in productIDs)
            {
                var productSales = reports.Where(x => x.ProductId == productId);
                var currentProd = entDb.Products.First(p => p.Id == productId);

                double productQuantity = 0;
                decimal income = 0;
                foreach (var sale in productSales)
                {
                    productQuantity += sale.Quantity;
                    income += sale.Sum;
                }

                MongoProduct product = new MongoProduct((int)currentProd.OldId,
                    currentProd.ProductName, currentProd.Vendor.VendorName, productQuantity, income);

                this.products.Insert(product);
            }
        }

        public MongoCollection<MongoProduct> GetProducts()
        {
            return this.products;
        }

        public static Dictionary<DateTime, Dictionary<int, DBManager.MongoEntry>> RetrieveTotalReport()
        {
            var result = new Dictionary<DateTime, Dictionary<int, DBManager.MongoEntry>>();
            var now = DateTime.Now;

            var mgr = new Manager();
            var products = mgr.GetProducts();

            result.Add(now, new Dictionary<int, DBManager.MongoEntry>());

            foreach (var prod in products.AsQueryable().ToList())
            {
                result[now].Add(prod.ProductId, new DBManager.MongoEntry()
                {
                    ProductName = prod.Name,
                    QuantitySold = prod.QuantitySold,
                    TotatIncome = prod.Income,
                    VendorName = prod.Vendor
                });
            }

            return result;
        }
    }
}
