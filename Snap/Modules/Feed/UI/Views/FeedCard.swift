//
//  FeedCard.swift
//  Snap
//
//  Created by Gordon Smith on 21/03/2021.
//

import Foundation
import SwiftUI

struct FeedCard: View {
    
    @EnvironmentObject private var imageProvider: ImageLoaderProvider
    
    private let item: Post
    
    init(item: Post) {
        self.item = item
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AvatarView(imageURL: item.user.imageURL)
                .frame(width: 48, height: 48)
                .padding(.leading)
                .padding(.bottom)
                .zIndex(1)
            
            VStack(spacing: 0) {
                AsyncImageView(
                    viewModel: .init(
                        imageURL: item.imageURL,
                        loadImagePublisher: imageProvider.make(),
                        imageTransformer: UIImage.init
                    )
                ).frame(height: 500)
                
                FeedCardFooterView(name: item.user.name, likes: item.likeCount)
                    .background(Color(.secondarySystemBackground))
            }
        }
    }
}
