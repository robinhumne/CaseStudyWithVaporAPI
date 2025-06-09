//
//  ProductListViewModel.swift
//  CaseStudyWithVaporAPI
//
//  Created by ROBIN HUMNE on 08/06/25.
//

import SwiftUI

@MainActor
class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var wishlistItems: [Product] = []

    private let userId: String = "user123"

    private let productService: ProductServiceProtocol
    init(productService: ProductServiceProtocol = MockProductService()) {
        self.productService = productService
    }
    
    func loadInitialData() {
        Task {
            await performInitialLoad()
        }
    }
    
    private func performInitialLoad() async {
        isLoading = true
        errorMessage = nil
        
        // Use async let to fetch both simultaneously
        async let productsTask = NetworkService.shared.fetchProducts()
        async let wishlistTask = NetworkService.shared.fetchWishlist(userId: userId)
        
        do {
            let (products, wishlistItems) = try await (productsTask, wishlistTask)
            self.products = products
            self.wishlistItems = wishlistItems
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }

    
    func fetchProducts() {
        Task {
            await performProductsFetch()
        }
    }

    func performProductsFetch() async {
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await NetworkService.shared.fetchProducts()
            /*
            //OFFLine Data
            productService.fetchProducts { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let products):
                        self?.products = products
                        self?.fetchWishlist()
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
            */
        } catch NetworkError.statusCode(let code) {
            errorMessage = "Server error (status code: \(code))"
        } catch NetworkError.decodingError {
            errorMessage = "Failed to decode products"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func fetchWishlist() {
        Task {
            await fetchProductsWishlist()
        }
    }
    
    func fetchProductsWishlist() async {
        isLoading = true
        errorMessage = nil
        
        do {
            wishlistItems = try await NetworkService.shared.fetchWishlist(userId: userId)
        } catch NetworkError.statusCode(let code) {
            errorMessage = "Server error (status code: \(code))"
        } catch NetworkError.decodingError {
            errorMessage = "Failed to decode products"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func toggleWishlist(product: Product) {
        Task {
            await toggleProductsWishlist(for: product)
        }
    }
    
    func toggleProductsWishlist(for product: Product) async {
        if wishlistItems.contains(product) {
            removeFromWishlist(productId: product.id)
        } else {
            addToWishlist(productId: product.id)
        }
    }
    
    func addToWishlist(productId: Int)  {
        Task {
            await addToProductsWishlist(productId: productId)
        }
    }

    func addToProductsWishlist(productId: Int)  async {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                try await NetworkService.shared.addToWishlist(userId: userId, productId: productId)
                fetchWishlist()
                errorMessage = "Successfully added to wishlist"
            } catch {
                errorMessage = "Error adding to wishlist: \(error)"
            }
        }
        isLoading = false
    }
    
    func removeFromWishlist(productId: Int)  {
        Task {
            await removeFromProductsWishlist(productId: productId)
        }
    }

    func removeFromProductsWishlist(productId: Int)  async {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await NetworkService.shared.removeFromWishlist(userId: userId, productId: productId)
                fetchWishlist()
                errorMessage = "Successfully removed from wishlist"
            } catch {
                errorMessage = "Error removing from wishlist: \(error)"
            }
        }
        isLoading = false
    }
}
