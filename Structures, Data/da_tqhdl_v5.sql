CREATE DATABASE IF NOT EXISTS tqhdl_V5;
use tqhdl_V5;

CREATE table roles(
	id INT NOT NULL,
	name text NOT NULL,
	PRIMARY KEY(id)
) ENGINE = INNODB;

CREATE table users(
	id INT NOT NULL,
	name text NOT NULL,
    user_name text NOT NULL,
    phone_number text NOT NULL,
    password text NOT NULL,
    role_id int NOT NULL,
	PRIMARY KEY(id)
) ENGINE = INNODB;

CREATE table addresses(
	id INT NOT NULL,
    user_id int NOT NULL,
    address_line text NOT NULL,
    district text NOT NULL,
    province text NOT NULL,
	PRIMARY KEY(id)
) ENGINE = INNODB;

CREATE table suppliers(
	id INT NOT NULL,
	name text NOT NULL,
	PRIMARY KEY(id)
) ENGINE = INNODB;

CREATE table product_categories(
	id INT NOT NULL,
	name text NOT NULL,
	PRIMARY KEY(id)
) ENGINE = INNODB;

CREATE table products(
	id INT NOT NULL,
	store_id int NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    product_category_id int NOT NULL,
    supplier_id int NOT NULL,
    image int,
    unit_price double NOT NULL,
    weight text NOT NULL,
    in_stock int NOT NULL,
    sold int,
	PRIMARY KEY(id)
) ENGINE = INNODB;

CREATE table order_statuses(
	id INT NOT NULL,
	name text NOT NULL,
	PRIMARY KEY(id)
) ENGINE = INNODB;

CREATE table payment_methods(
	id INT NOT NULL,
	name text NOT NULL,
	PRIMARY KEY(id)
) ENGINE = INNODB;

CREATE table orders(
	id INT NOT NULL,
    customer_id int NOT NULL,
	store_id int NOT NULL,
    shipper_id int NOT NULL,
    order_status_id int NOT NULL,
    shipping_address text NOT NULL,	
    payment_method_id int NOT NULL,
    total_price double NOT NULL,
    total_weight double NOT NULL DEFAULT 0,
    created_at timestamp NOT NULL,
    delivered_at timestamp NOT NULL,
	PRIMARY KEY(id)
) ENGINE = INNODB;

CREATE table order_details(
	id INT NOT NULL,
    order_id int NOT NULL,
    product_id int NOT NULL,
    unit int  NOT NULL,
	subtotal_price double NOT NULL,
    subtotal_weight double NOT NULL,
	PRIMARY KEY(id)
) ENGINE = INNODB;

CREATE table product_reviews(
	id INT NOT NULL,
    order_detail_id int NOT NULL,
    product_id int NOT NULL,
    rating int NOT NULL,
    packaging_rating int NOT NULL,
    review text NOT NULL,
    created_at datetime,
	PRIMARY KEY(id)
) ENGINE = INNODB;

ALTER TABLE users ADD CONSTRAINT fk_users_role FOREIGN KEY(role_id) REFERENCES roles(id);
ALTER TABLE products ADD FOREIGN KEY(product_category_id) REFERENCES product_categories(id);
ALTER TABLE products ADD FOREIGN KEY(supplier_id) REFERENCES suppliers(id);
ALTER TABLE order_details ADD FOREIGN KEY(order_id) REFERENCES orders(id);
ALTER TABLE order_details ADD FOREIGN KEY(product_id) REFERENCES products(id);
ALTER TABLE orders ADD FOREIGN KEY(customer_id) REFERENCES users(id);
ALTER TABLE orders ADD FOREIGN KEY(order_status_id) REFERENCES order_statuses(id);
ALTER TABLE orders ADD FOREIGN KEY(payment_method_id) REFERENCES payment_methods(id);
ALTER TABLE product_reviews ADD FOREIGN KEY(order_detail_id) REFERENCES order_details(id);
ALTER TABLE product_reviews ADD FOREIGN KEY(product_id) REFERENCES products(id);