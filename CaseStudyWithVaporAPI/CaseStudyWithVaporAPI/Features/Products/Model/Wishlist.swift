//
//  Wishlist.swift
//  CaseStudyWithVaporAPI
//
//  Created by ROBIN HUMNE on 09/06/25.
//
import Foundation

struct WishlistResponse: Decodable {
    let items: [Product]
}

struct WishlistItem: Codable {
    let userId: String
    let productId: Int
}
