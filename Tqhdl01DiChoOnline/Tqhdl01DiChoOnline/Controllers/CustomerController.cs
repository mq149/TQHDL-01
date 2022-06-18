using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Tqhdl01DiChoOnline.Database;

namespace Tqhdl01DiChoOnline.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomerController
    {
        private readonly IConfiguration _configuration;

        public CustomerController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet("by-region")]
        public JsonResult ByRegion(int? storeId)
        {
            string query = @"
                    SELECT COUNT(sub.customer_id) as customers, sub.district, sub.province
                    FROM (
                        SELECT u.id as customer_id, a.district as district, a.province as province
                        FROM orders o
                            JOIN users u ON o.customer_id = u.id
                            JOIN addresses a ON a.user_id = u.id ";
            if (storeId != null)
            {
                query += "WHERE o.store_id = " + storeId.Value + " ";
            }
            query += @"
                    GROUP BY customer_id
                ) as sub
                GROUP BY sub.district, sub.province
                ORDER BY customers DESC";
            var table = MySqlDb.executeQuery(_configuration, query);
            return new JsonResult(table);
        }
    }
}
