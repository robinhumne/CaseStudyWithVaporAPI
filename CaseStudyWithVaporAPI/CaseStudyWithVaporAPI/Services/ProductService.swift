//
//  ProductService.swift
//  CaseStudyWithVaporAPI
//
//  Created by ROBIN HUMNE on 08/06/25.
//

import Foundation
protocol ProductServiceProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void)
}

class MockProductService: ProductServiceProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        // Load from local JSON file
        if let url = Bundle.main.url(forResource: "products", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let response = try decoder.decode(ProductResponse.self, from: data)
                completion(.success(response.products))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load products"])))
        }
    }
}
