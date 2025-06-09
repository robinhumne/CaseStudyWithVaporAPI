//
//  Product.swift
//  CaseStudyWithVaporAPI
//
//  Created by ROBIN HUMNE on 08/06/25.
//
struct Product: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let originalPrice: String
    let salePrice: String
    let brandName: String
    let discountPercentage: String?
    let image: ProductImage
    let badges: [ProductBadge]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, originalPrice, salePrice, brandName, image, badges, discountPercentage
    }
}

struct ProductImage: Codable, Hashable {
    let url: String
    let height: Int
    let width: Int
    let gender: String?
}

struct ProductBadge: Codable, Hashable {
    let text: String
}

struct ProductResponse: Codable {
    let products: [Product]
}
