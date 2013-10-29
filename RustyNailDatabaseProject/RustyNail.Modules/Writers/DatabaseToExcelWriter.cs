namespace RustyNail.Modules
{
    using System;
    using System.Collections.Generic;
    using System.Data.OleDb;
    using System.Linq;
    using System.IO;
    using RustyNail.Data;
    
    public class DatabaseToExcelWriter
    {
        static readonly string filePath = "..//..//Products-Total-Report.xlsx";
        static readonly string connection =
               "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";" +
                 @"Extended Properties=""Excel 12.0 Xml;HDR=YES"";";
        static string day = DateTime.Now.ToString("MMMM yyyy");

        private static void CreateTable(OleDbConnection connection, Dictionary<string, DBManager.ProductTotalReport> reports)
        {
            OleDbCommand excelCmd = new OleDbCommand(
                "CREATE TABLE [" + day + @"] (Vendor string, Income double, Expenses double, 
                Taxes double, [Financial Result] double)", connection);
            excelCmd.ExecuteNonQuery();
        }

        private static void InsertValues(OleDbConnection connection, Dictionary<string, DBManager.ProductTotalReport> reports)
        {
            foreach (var report in reports)
            {
                OleDbCommand excelCmd = new OleDbCommand(
            "INSERT INTO [" + day + "] (Vendor, Income, Expenses, Taxes, [Financial Result])"
            + "VALUES(@vendor, @income, @expenses, @taxes, @fResult)", connection);
                excelCmd.Parameters.AddWithValue("@vendor", report.Key);
                excelCmd.Parameters.AddWithValue("@income", (double)report.Value.Incomes);
                excelCmd.Parameters.AddWithValue("@expenses", (double)report.Value.Expenses);
                excelCmd.Parameters.AddWithValue("@taxes", (double)report.Value.Taxes);
                excelCmd.Parameters.AddWithValue("@fResult", (double)report.Value.FinancalResult);
                excelCmd.ExecuteNonQuery();
            }
        }

        public static void CreateExcelTable(Dictionary<string, DBManager.ProductTotalReport> reports)
        {
            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }

            OleDbConnection excelCon = new OleDbConnection(connection);
            excelCon.Open();
            using (excelCon)
            {
                CreateTable(excelCon, reports);
                InsertValues(excelCon, reports);
            }
        }
    }
}
