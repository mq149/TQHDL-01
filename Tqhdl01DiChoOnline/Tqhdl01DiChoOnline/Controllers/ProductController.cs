using System;
using System.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using MySql.Data.MySqlClient;
using Tqhdl01DiChoOnline.Database;

namespace Tqhdl01DiChoOnline.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController
    {
        private readonly IConfiguration _configuration;

        public ProductController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet("most-sold")]
        public JsonResult MostSold(int? storeId, int limit = 10)
        {
            string query = @"
                    SELECT p.id as product_id, p.name as product_name, SUM(od.unit) as unit
                    FROM orders as o 
                        JOIN order_details as od ON o.id = od.order_id
	                    JOIN products as p ON od.product_id = p.id ";
            if (storeId != null)
            {
                query += "WHERE o.store_id = " + storeId.Value + " ";
            }
            query += @"
                GROUP BY product_id, product_name
                ORDER BY unit DESC
                LIMIT " + limit;
            var table = MySqlDb.executeQuery(_configuration, query);
            return new JsonResult(table);
        }

        [HttpGet("least-sold")]
        public JsonResult LeastSold(int? storeId, int limit = 10)
        {
            string query = @"
                    SELECT p.id as product_id, p.name as product_name, SUM(od.unit) as unit
                    FROM orders as o 
                        JOIN order_details as od ON o.id = od.order_id
	                    JOIN products as p ON od.product_id = p.id ";
            if (storeId != null)
            {
                query += "WHERE o.store_id = " + storeId.Value + " ";
            }
            query += @"
                GROUP BY product_id, product_name
                ORDER BY unit
                LIMIT " + limit;
            var table = MySqlDb.executeQuery(_configuration, query);
            return new JsonResult(table);
        }

        [HttpGet("running-low")]
        public JsonResult RunningLow(int? storeId, int limit = 10)
        {
            string query = @"
                    SELECT id, name, in_stock
                    FROM products
                    WHERE in_stock <= 200 ";
            if (storeId != null)
            {
                query += "AND store_id = " + storeId.Value + " ";
            }
            query += @"ORDER BY in_stock";
            var table = MySqlDb.executeQuery(_configuration, query);
            return new JsonResult(table);
        }
    }
}
