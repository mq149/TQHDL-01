using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Tqhdl01DiChoOnline.Database;

namespace Tqhdl01DiChoOnline.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RevenueController
    {
        private readonly IConfiguration _configuration;

        public RevenueController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet("get")]
        public JsonResult Get(int? storeId)
        {
            string query = @"
                    SELECT r.revenue as revenue,
	                    LEFT(r.d, 7) as month,
	                    r_prev.revenue as previous_revenue,
	                    LEFT(r_prev.d, 7) as previous_month,
	                    (100 * (r.revenue - r_prev.revenue) / r_prev.revenue) as percentage
                    FROM
                        (
                            SELECT SUM(o.total_price) as revenue, CONCAT(LEFT(o.created_at, 7), ""-01"") as d
                            FROM orders as o
                                JOIN order_details as od ON o.id = od.order_id
                            " + (storeId.HasValue ? "WHERE o.store_id = " + storeId.Value : "") +
                            @"
                            GROUP BY d
                        ) as r
                        LEFT JOIN
                        (
                            SELECT SUM(o.total_price) as revenue, CONCAT(LEFT(o.created_at, 7), ""-01"") as d
                            FROM orders as o
                                JOIN order_details as od ON o.id = od.order_id
                            " + (storeId.HasValue ? "WHERE o.store_id = " + storeId.Value : "") +
                            @"
                            GROUP BY d
                        ) as r_prev
                        ON DATE(r.d) = DATE(r_prev.d) + INTERVAL 1 MONTH
                    ORDER BY month";
            var table = MySqlDb.executeQuery(_configuration, query);
            return new JsonResult(table);
        }
    }
}
