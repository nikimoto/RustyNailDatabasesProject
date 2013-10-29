namespace RustyNail.Modules.MongoManager
{
    using MongoDB.Driver;
    using MongoDB.Driver.Linq;
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    public class ProductsReport : IEnumerable
    {
        private MongoCollection<MongoProduct> products;
        private IQueryable<MongoProduct> queryableProducts;

        public ProductsReport(MongoCollection<MongoProduct> products)
        {
            this.products = products;
            this.queryableProducts = products.AsQueryable<MongoProduct>();
        }

        public bool Add(MongoProduct prod)
        {
            if (!this.Contains(prod.ProductId))
            {
                this.products.Insert(prod);
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool Contains(int id)
        {
            return this.queryableProducts.Any(x => x.ProductId == id);
        }

        public IEnumerator<MongoProduct> GetEnumerator()
        {
            var allProducts = queryableProducts.ToList();

            foreach (var product in allProducts)
            {
                yield return product;
            }
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}
