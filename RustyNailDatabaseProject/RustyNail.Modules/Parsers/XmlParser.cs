using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace RustyNail.Modules
{
    public class XmlParser
    {
        public Dictionary<string, Dictionary<DateTime, Decimal>> ParseFile(string inputPath)
        {
            XDocument xmlDoc = XDocument.Load(inputPath);
            var sales =
                from sale in xmlDoc.Descendants("sale")
                select sale;

            var expensesData = new Dictionary<string, Dictionary<DateTime, Decimal>>();

            foreach (var item in sales)
            {
                var expenses = GetExpenses(item);
                var vendorName = item.Attribute("vendor").Value;
                expensesData.Add(vendorName, expenses);
            }

            return expensesData;
        }

        private static Dictionary<DateTime, Decimal> GetExpenses(XElement item)
        {
            var expenses = new Dictionary<DateTime, Decimal>();
            CultureInfo.DefaultThreadCurrentCulture = CultureInfo.InvariantCulture;
            foreach (var child in item.Elements())
            {
                var monthAsString = "01-" + child.Attribute("month").Value;
                var month = DateTime.Parse(monthAsString);
                var price = decimal.Parse(child.Value);
                expenses.Add(month, price);
            }
            return expenses;
        }
    }
}
