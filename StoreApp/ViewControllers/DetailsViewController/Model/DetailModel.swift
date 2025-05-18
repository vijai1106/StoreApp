//
//  DetailModel.swift
//  StoreApp
//
//  Created by Vijai S on 18/05/25.
//

import Foundation

struct ProductDetailResponse: Codable {
    let productDetails: ProductDetails
    
    enum CodingKeys: String, CodingKey {
        case productDetails = "ProductDetails"
    }
}

struct ProductDetails: Codable {
    let productInfoDetails: [ProductInfo]
    let productImageDetails: [ProductImage]
    
    enum CodingKeys: String, CodingKey {
        case productInfoDetails = "productInfoDetails"
        case productImageDetails = "productImageDetails"
    }
}

struct ProductInfo: Codable {
    let societyProductID: Int
    let productID: Int
    let title: String
    let categoryID: Int
    let subcategoryID: Int
    let categoryTitle: String
    let subCategoryTitle: String
    let description: String
    let mrp: Double
    let finalPrice: Double
    let unit: String
    let addedToCart: String
    let cartId: Int
    let cartQuantity: Int
    let cartCount: Int
    
    enum CodingKeys: String, CodingKey {
        case societyProductID = "SocietyproductID"
        case productID = "ProductID"
        case title = "Title"
        case categoryID = "CategoryID"
        case subcategoryID = "SubcategoryID"
        case categoryTitle = "CategoryTitle"
        case subCategoryTitle = "SubCategoryTitle"
        case description = "Description"
        case mrp = "Mrp"
        case finalPrice = "Finalprice"
        case unit = "Unit"
        case addedToCart = "AddedtoCart"
        case cartId = "CartId"
        case cartQuantity = "CartQuantity"
        case cartCount = "CartCount"
    }
}

struct ProductImage: Codable {
    let productImageID: Int
    let originalImage: String
    let thumbImage: String
    let isDefault: Int
    
    enum CodingKeys: String, CodingKey {
        case productImageID = "ProductImageID"
        case originalImage = "OriginalImage"
        case thumbImage = "ThumbImage"
        case isDefault = "IsDefault"
    }
}
