//
//  WishlistView.swift
//  CaseStudyWithVaporAPI
//
//  Created by ROBIN HUMNE on 08/06/25.
//
import SwiftUI

struct WishlistView: View {
    @ObservedObject var viewModel: ProductListViewModel
    @Environment(\.dismiss) var dismiss

    var wishlistProducts: [Product] {
        viewModel.wishlistItems
    }

    var body: some View {
        NavigationView {
            Group {
                if wishlistProducts.isEmpty {
                    VStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                            .padding()
                        Text("Your wishlist is empty")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("Add your favorite products to your wishlist\n and they will appear here.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(wishlistProducts) { product in
                            HStack {
                                AsyncImage(url: URL(string: product.image.url)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 60)
                                    } else if phase.error != nil {
                                        Color.gray
                                            .frame(width: 60, height: 60)
                                    } else {
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(product.brandName)
                                        .font(.caption)
                                    Text(product.name)
                                        .font(.subheadline)
                                    HStack(spacing: 4) {
                                        Text(product.salePrice)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                        
                                        Text(product.originalPrice)
                                            .strikethrough()
                                            .font(.subheadline)
                                            .fontWeight(.regular)
                                        
                                        if let discount = product.discountPercentage {
                                            Text(discount)
                                                .font(.caption2)
                                                .foregroundColor(.red)
                                                .padding(4)
                                                .background(Color.red.opacity(0.1))
                                                .cornerRadius(4)
                                        }
                                    }
                                    
                                    if let badges = product.badges, !badges.isEmpty {
                                        HStack(spacing: 4) {
                                            ForEach(badges, id: \.text) { badge in
                                                Text(badge.text)
                                                    .font(.caption2)
                                                    .padding(4)
                                                    .background(Color.black.opacity(0.7))
                                                    .foregroundColor(.white)
                                                    .cornerRadius(4)
                                            }
                                        }
                                        .padding(8)
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.toggleWishlist(product: product)
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete { indices in
                            for index in indices {
                                let product = wishlistProducts[index]
                                viewModel.removeFromWishlist(productId: product.id)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Wishlist")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.fetchWishlist()
            }
        }
    }
}
