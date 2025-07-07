// ==========================
// USERS COLLECTION
// ==========================
{
  "_id": ObjectId(),
  "username": "pratyush",
  "email": "pratyush@example.com",
  "password": "hashed_password",
  "role": "USER", // USER or ADMIN
  "profile_picture": "profile.jpg",
  "bio": "Developer | Admin bio here",
  "is_verified": false,
  "github_username": "pratyush-github",
  "account_type": "VENDOR", // VENDOR or BUYER
  "created_at": ISODate(),
  "updated_at": ISODate()
}

// ==========================
// TOKENS COLLECTION
// ==========================
{
  "_id": ObjectId(),
  "user_id": ObjectId(), // Reference to users
  "refresh_token": "some_random_refresh_token", // stored in DB and cookies
  "user_agent": "browser info", // optional, for security
  "ip_address": "optional", // for security tracking
  "is_valid": true,
  "created_at": ISODate(),
  "expires_at": ISODate()
}

// ==========================
// PRODUCTS COLLECTION
// ==========================
{
  "_id": ObjectId(),
  "user_id": ObjectId(), // Vendor who uploaded
  "title": "Beautiful Login UI",
  "description": "Responsive Flutter Login UI",
  "product_type": "UI_COMPONENT", // or FULL_PROJECT
  "price": 20.00,
  "discounted_price": 15.00, // Optional, can be null
  "language": "Dart",
  "framework": "Flutter",
  "tags": ["UI", "Login", "Mobile"], // Array of tags
  "images": ["image1.jpg", "image2.jpg"], // Array of image URLs
  "demo_link": "https://demo.example.com", // Optional
  "code_quality": "GOOD", // AI evaluated
  "is_responsive": true,
  "platform": "MOBILE", // DESKTOP or BOTH
  "zip_file_path": "uploads/abc.zip", // Mandatory ZIP upload
  "created_at": ISODate(),
  "updated_at": ISODate()
}

// ==========================
// FAVORITES COLLECTION
// ==========================
{
  "_id": ObjectId(),
  "user_id": ObjectId(),
  "product_id": ObjectId(),
  "created_at": ISODate()
}

// ==========================
// REVIEWS COLLECTION
// ==========================
{
  "_id": ObjectId(),
  "product_id": ObjectId(),
  "user_id": ObjectId(),
  "rating": 4, // Range: 1-5
  "comment": "Great code quality and easy to integrate!",
  "created_at": ISODate()
}

// ==========================
// ORDERS COLLECTION
// ==========================
{
  "_id": ObjectId(),
  "buyer_id": ObjectId(), // Who bought
  "product_id": ObjectId(),
  "vendor_id": ObjectId(), // Seller
  "price": 20.00,
  "discounted_price": 15.00, // Price buyer paid
  "platform_fee": 2.00,
  "seller_earning": 13.00,
  "payment_status": "PAID", // PENDING, PAID, FAILED
  "delivery_type": "ZIP", // Always ZIP
  "zip_file_path": "uploads/abc.zip",
  "created_at": ISODate()
}
