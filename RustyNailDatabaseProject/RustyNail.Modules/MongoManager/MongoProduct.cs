namespace RustyNail.Modules.MongoManager
{
    using MongoDB.Bson;
    using MongoDB.Bson.Serialization.Attributes;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    public class MongoProduct
    {
        public MongoProduct(int id, string name, string vendor,
            double quantitySold, decimal income)
        {
            this.ProductId = id;
            this.Name = name;
            this.Vendor = vendor;
            this.QuantitySold = quantitySold;
            this.Income = income;
        }

        [BsonId]
        public ObjectId Id { get; set; }

        public int ProductId { get; set; }

        public string Name { get; set; }

        public string Vendor { get; set; }

        public double QuantitySold { get; set; }

        public decimal Income { get; set; }
    }
}
