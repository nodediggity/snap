//
//  AvatarView.swift
//  Snap
//
//  Created by Gordon Smith on 21/03/2021.
//

import Foundation
import SwiftUI

struct AvatarView: View {
    
    @EnvironmentObject var imageProvider: ImageLoaderProvider
    
    private let imageURL: URL
    
    init(imageURL: URL) {
        self.imageURL = imageURL
    }
    
    var body: some View {
        
        AsyncImageView(
            viewModel: .init(
                imageURL: imageURL,
                loadImagePublisher: imageProvider.make(),
                imageTransformer: UIImage.init
            ),
            canRetry: false
        )
        .clipShape(Circle())
        .overlay(Circle().stroke(Color(.secondarySystemBackground), lineWidth: 1))
    }
}
