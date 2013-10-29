namespace RustyNail.Modules
{
    using RustyNail.Data;
    using RustyNail.ProductsData;
    using System;
    using System.Linq;

    public class InitModules
    {
        static ProductsModel productsModel;
        static SupermarketEntities market;

        public static void PopulateProducts()
        {
            productsModel = new ProductsModel();
            market = new SupermarketEntities();
            AddMeasurements();
            AddVendors();
            AddProducts();
        }

        private static void AddMeasurements()
        {
            foreach (var measurement in productsModel.Measures)
            {
                if (!market.Measures.Where(m => m.MeasureName == measurement.MeasureName).Any())
                {
                    market.Measures.Add(new RustyNail.Data.Measure()
                    {
                        MeasureName = measurement.MeasureName
                    });
                }
            }

            market.SaveChanges();
        }

        private static void AddVendors()
        {
            foreach (var vendor in productsModel.Vendors)
            {
                if (!market.Vendors.Where(v => v.VendorName == vendor.VendorName).Any())
                {
                    market.Vendors.Add(new RustyNail.Data.Vendor()
                    {
                        VendorName = vendor.VendorName
                    });
                }
            }

            market.SaveChanges();
        }

        private static void AddProducts()
        {
            foreach (var product in productsModel.Products)
            {
                if (!market.Products.Where(p => p.ProductName == product.ProductName).Any())
                {
                    var vendor = market.Vendors
                        .First(v => v.VendorName == product.Vendor.VendorName);
                    var measurement = market.Measures
                        .First(m => m.MeasureName == product.Measure.MeasureName);
                    market.Products.Add(new RustyNail.Data.Product()
                    {
                        ProductName = product.ProductName,
                        BasePrice = product.BasePrice,
                        VendorId = vendor.Id,
                        MeasureId = measurement.Id,
                        OldId = product.Id
                    });
                }

                market.SaveChanges();
            }

        }
    }
}
