namespace RustyNail.Modules
{
    using Ionic.Zip;
    using RustyNail.Data;
    using System;
    using System.Collections.Generic;
    using System.Data.OleDb;
    using System.Globalization;
    using System.IO;

    public class ExcelParser
    {
        public static List<StoreReport> ParseExcel(string path)
        {
            List<StoreReport> reportsList = new List<StoreReport>();            
            string format = "dd-MMM-yyyy";
            CultureInfo provider = CultureInfo.InvariantCulture;

            using (ZipFile zip = ZipFile.Read(path + "Sample-Sales-Reports.zip"))
            {
                zip.ExtractAll(path, ExtractExistingFileAction.OverwriteSilently);
                
                string dateAsString = string.Empty;
                string folderName = string.Empty;
                DateTime entryDate = DateTime.Now;
                foreach (ZipEntry e in zip)
                {
                    StoreReport reportEntry = new StoreReport();
                    var filename = e.FileName.ToString();                    
                    if (e.IsDirectory)
                    {
                        if (!string.IsNullOrWhiteSpace(folderName))
                        {
                            Directory.Delete(path + "\\" + folderName, true);
                        }
                        for (int i = 0; i < filename.Length - 1; i++)
                        {
                            dateAsString += filename[i];
                        }

                        folderName = dateAsString;
                        entryDate = DateTime.ParseExact(dateAsString, format, provider);
                        dateAsString = string.Empty;
                    }
                    else
                    {
                        int index = filename.IndexOf("/");
                        string excelFileName = filename.Substring(index + 1);
                        string DbSource = path + folderName + "\\" + excelFileName + ";";
                        string connectionString =
                            @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + DbSource +
                            @"Extended Properties=""Excel 12.0 Xml;HDR=YES"";";

                        OleDbConnection excelConn = new OleDbConnection(connectionString);
                        excelConn.Open();

                        using (excelConn)
                        {
                            OleDbCommand cmdExcelTable = new OleDbCommand(
                                @"SELECT * FROM [Sales$]", excelConn);
                            OleDbDataReader reader = cmdExcelTable.ExecuteReader();
                            using (reader)
                            {
                                reader.Read();
                                string supermarketName = (string)reader[0];
                                reportEntry.MarketName = supermarketName;
                                //Console.WriteLine(supermarketName);
                                reader.Read();
                                decimal totalSum;
                                while (reader.Read())
                                {
                                    string productIdAsString = (string)reader[0];
                                    if (productIdAsString == "Total sum:")
                                    {
                                        totalSum = decimal.Parse(reader[3].ToString());
                                        reportEntry.TotalSum = totalSum;
                                        //Console.WriteLine("Total Sum {0}", totalSum);
                                        break;
                                    }
                                    int productId = int.Parse(productIdAsString);
                                    double quantity = double.Parse(reader[1].ToString());
                                    decimal price = decimal.Parse(reader[2].ToString());
                                    decimal sum = decimal.Parse(reader[3].ToString());
                                    reportEntry.Products.Add(new Entry { 
                                        ProductId = productId,
                                        QuantityValue = quantity,
                                        UnitPrice = price,
                                        Location = supermarketName,
                                        Sum = sum});

                                    //Console.WriteLine("ID: {0}; Quantity: {1}, Price: {3}, Sum: {2}", productId, quantity, sum, price);
                                }

                                reportEntry.Date = entryDate;
                            }

                            reportsList.Add(reportEntry);
                        }
                    }
                }

                Directory.Delete(path + "\\" + folderName, true);
            }

            return reportsList;
        }
    }
}
