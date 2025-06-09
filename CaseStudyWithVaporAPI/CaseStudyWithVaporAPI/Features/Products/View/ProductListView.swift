//
//  ProductListView.swift
//  CaseStudyWithVaporAPI
//
//  Created by ROBIN HUMNE on 08/06/25.
//
import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()
    @State private var showWishlist = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading products...")
                        .scaleEffect(1.5)
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage) {
                        viewModel.fetchProducts()
                    }
                } else if viewModel.products.isEmpty {
                    Text("No products available")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(viewModel.products) { product in
                                ProductCardView(product: product, isInWishlist: viewModel.wishlistItems.contains(product)) {
                                    viewModel.toggleWishlist(product: product)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showWishlist = true
                    }) {
                        Image(systemName: viewModel.wishlistItems.isEmpty ? "heart" : "heart.fill")
                        .foregroundColor(viewModel.wishlistItems.isEmpty ? .gray : .red)
                    }
                }
            }
            .sheet(isPresented: $showWishlist) {
                WishlistView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadInitialData()
            }
        }
    }
}
