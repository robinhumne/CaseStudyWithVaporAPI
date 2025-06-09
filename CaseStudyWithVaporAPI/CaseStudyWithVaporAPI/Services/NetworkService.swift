//
//  NetworkService.swift
//  CaseStudyWithVaporAPI
//
//  Created by ROBIN HUMNE on 09/06/25.
//
import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError(Error)
    case unknownError
}

class NetworkService {
    static let shared = NetworkService()
    private init() {}

    private let baseURL = "http://localhost:8080"
    private let urlSession = URLSession.shared
    
    // MARK: - Fetch Products
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "\(baseURL)/products") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        do {
            let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
            return productResponse.products
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Wishlist Operations
    func fetchWishlist(userId: String) async throws -> [Product] {
        guard let url = URL(string: "\(baseURL)/wishlist/\(userId)") else {
            throw NetworkError.invalidURL
        }
                
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        do {
            let wishlistResponse = try JSONDecoder().decode(WishlistResponse.self, from: data)
            return wishlistResponse.items
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func addToWishlist(userId: String, productId: Int) async throws {
        guard let url = URL(string: "\(baseURL)/wishlist/\(userId)/\(productId)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (_, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 201 else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
    }
    
    func removeFromWishlist(userId: String, productId: Int) async throws {
        guard let url = URL(string: "\(baseURL)/wishlist/\(userId)/\(productId)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 204 else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
    }
}
