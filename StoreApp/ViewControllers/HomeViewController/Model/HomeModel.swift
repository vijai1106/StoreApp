//
//  HomeModel.swift
//  StoreApp
//
//  Created by Vijai S on 18/05/25.
//

import Foundation

struct ProductResponse: Codable {
    var searchProductMobile: [Product]
    var totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case searchProductMobile = "SearchProductMobile"
        case totalCount = "TotalCount"
    }
}

struct Product: Codable {
    var societyProductID: Int
    var title: String
    var originalImage: String
    var thumbImage: String
    var finalPrice: Double
    var mrp: Double
    var cartQuantity: Int
    var totalCount: Int
    var cartId: Int
    var cartCount: Int
    var unit: String
    
    enum CodingKeys: String, CodingKey {
        case societyProductID = "SocietyproductID"
        case title = "Title"
        case originalImage = "OriginalImage"
        case thumbImage = "ThumbImage"
        case finalPrice = "Finalprice"
        case mrp = "Mrp"
        case cartQuantity = "CartQuantity"
        case totalCount = "TotalCount"
        case cartId = "CartId"
        case cartCount = "CartCount"
        case unit = "Unit"
    }
}
