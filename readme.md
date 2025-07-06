CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    profile_picture VARCHAR(255),
    bio('ADMIN') VARCHAR(255),
    is_verified BOOLEAN DEFAULT FALSE, -- optional email verification
    github_username VARCHAR(100), -- optional if user shares repo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE refresh_tokens (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    token VARCHAR(500) NOT NULL,
    expiry_date TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL, 
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    product_type ENUM('UI_COMPONENT', 'FULL_PROJECT') NOT NULL,
    delivery_type ENUM('ZIP', 'GITHUB_LINK') NOT NULL,
    delivery_link VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    language VARCHAR(50) NOT NULL,
    framework VARCHAR(50) NOT NULL,
    tags VARCHAR(255), -- CSV or separate tags table
    demo_link VARCHAR(255),
    code_quality ENUM('Top notch','EXCELLENT', 'GOOD', 'AVERAGE', 'POOR') DEFAULT 'GOOD',
    is_responsive BOOLEAN DEFAULT TRUE,
    platform ENUM('MOBILE', 'DESKTOP', 'BOTH') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
);

CREATE TABLE favorites (
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE

);

CREATE TABLE reviews (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    price DECIMAL(10,2) NOT NULL, -- total price paid by user
    platform_fee DECIMAL(10,2) NOT NULL, -- fee charged by platform
    seller_earning DECIMAL(10,2) NOT NULL, -- price - platform_fee
    payment_status ENUM('PENDING', 'PAID', 'FAILED') DEFAULT 'PAID',
    delivery_type ENUM('ZIP', 'GITHUB_LINK') NOT NULL,
    delivery_link VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

