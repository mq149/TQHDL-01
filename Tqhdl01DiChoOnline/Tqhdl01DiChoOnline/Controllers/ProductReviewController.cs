using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Tqhdl01DiChoOnline.Database;

namespace Tqhdl01DiChoOnline.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductReviewController
    {
        private readonly IConfiguration _configuration;

        public ProductReviewController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet("average/by-product")]
        public JsonResult ByProduct(int? storeId, int limit = 5)
        {
            string query = @"
                    SELECT p.id as product_id, p.name as product_name, AVG(pr.rating) as average_rating
                    FROM product_reviews pr
	                    JOIN products p ON p.id = pr.product_id ";
            if (storeId != null)
            {
                query += "WHERE p.store_id = " + storeId.Value + " ";
            }
            query += @"
                GROUP BY product_id, product_name
                LIMIT " + limit;
            var table = MySqlDb.executeQuery(_configuration, query);
            return new JsonResult(table);
        }

        [HttpGet("average/by-product-category")]
        public JsonResult ByProductCategory(int? storeId, int limit = 5)
        {
            string query = @"
                    SELECT pc.id as product_category_id, pc.name as product_category_name, AVG(pr.rating) as average_rating
                    FROM product_reviews pr
	                    JOIN products p ON p.id = pr.product_id
	                    JOIN product_categories pc ON pc.id = p.product_category_id ";
            if (storeId != null)
            {
                query += "WHERE p.store_id = " + storeId.Value + " ";
            }
            query += @"
                GROUP BY product_category_id, product_category_name
                LIMIT " + limit;
            var table = MySqlDb.executeQuery(_configuration, query);
            return new JsonResult(table);
        }

        [HttpGet("worst-rated/product")]
        public JsonResult WorstRatedProducts(int? storeId, int limit = 5)
        {
            string query = @"
                    SELECT p.id as product_id, p.name as product_name, pr.rating as rating, COUNT(*) as count
                    FROM product_reviews pr
	                    JOIN products p ON p.id = pr.product_id
                    WHERE pr.rating = 1 ";
            if (storeId != null)
            {
                query += "AND p.store_id = " + storeId.Value + " ";
            }
            query += @"
                GROUP BY product_id, product_name, rating
                ORDER BY count DESC
                LIMIT " + limit;
            var table = MySqlDb.executeQuery(_configuration, query);
            return new JsonResult(table);
        }

        [HttpGet("worst-rated/product-category")]
        public JsonResult WorstRatedProductCategories(int? storeId, int limit = 5)
        {
            string query = @"
                    SELECT pc.id as product_category_id, pc.name as product_category_name, pr.rating as rating, COUNT(*) as count
                    FROM product_reviews pr
	                    JOIN products p ON p.id = pr.product_id
	                    JOIN product_categories pc ON pc.id = p.product_category_id
                    WHERE pr.rating = 1 ";
            if (storeId != null)
            {
                query += "AND p.store_id = " + storeId.Value + " ";
            }
            query += @"
                GROUP BY product_category_id, product_category_name, rating
                ORDER BY count DESC
                LIMIT " + limit;
            var table = MySqlDb.executeQuery(_configuration, query);
            return new JsonResult(table);
        }
    }
}
