using System;
using System.Data;
using Microsoft.Extensions.Configuration;
using MySql.Data.MySqlClient;

namespace Tqhdl01DiChoOnline.Database
{
    public class MySqlDb
    {
        public static DataTable executeQuery(IConfiguration _configuration, string query)
        {
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("TQHDL_V5");
            MySqlDataReader myReader;
            using (MySqlConnection myCon = new MySqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (MySqlCommand myCmd = new MySqlCommand(query, myCon))
                {
                    myReader = myCmd.ExecuteReader();
                    table.Load(myReader);

                    myReader.Close();
                    myCon.Close();
                }
            }
            return table;
        }
    }
}
