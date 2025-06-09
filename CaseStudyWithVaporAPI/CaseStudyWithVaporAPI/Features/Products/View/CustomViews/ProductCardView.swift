//
//  ProductCardView.swift
//  CaseStudyWithVaporAPI
//
//  Created by ROBIN HUMNE on 08/06/25.
//
import SwiftUI
import CachedAsyncImage

struct ProductCardView: View {
    let product: Product
    let isInWishlist: Bool
    let toggleWishlist: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .center) {
                CachedAsyncImage(url: URL(string: product.image.url)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .foregroundColor(Color.gray.opacity(0.1))
                            .aspectRatio(contentMode: .fit)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 150)
                
                Button(action: toggleWishlist) {
                    Image(systemName: isInWishlist ? "heart.fill" : "heart")
                        .foregroundColor(isInWishlist ? .red : .gray)
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(8)
            }
            .background(Color.gray.opacity(0.1))
            
            Text(product.brandName)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(product.name)
                .font(.subheadline)
                .lineLimit(2)
            
            HStack(spacing: 4) {
                Text(product.salePrice)
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                if let discount = product.discountPercentage {
                    Text(discount)
                        .font(.caption2)
                        .foregroundColor(.red)
                        .padding(4)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(4)
                }
            }
        }
    }
}
