//
//  FeedListView.swift
//  Snap
//
//  Created by Gordon Smith on 19/03/2021.
//

import Foundation
import SwiftUI

struct FeedListView: View {
    
    @EnvironmentObject var imageProvider: ImageLoaderProvider
    @ObservedObject private var viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Group {
            switch viewModel.state {
                case .loading:
                    LoadingView()
                        .frame(width: 50.0, height: 50.0)
                        .foregroundColor(Color("3dc6a7"))
                        .onAppear(perform: viewModel.loadFeed)
                    
                case let .loaded(feed):
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(spacing: 0) {
                            ForEach(feed, id: \.id) { item in
                                
                                AsyncImageView(
                                    viewModel: .init(
                                        imageURL: item.imageURL,
                                        loadImagePublisher: imageProvider.make(),
                                        imageTransformer: UIImage.init
                                    )
                                ).frame(height: 400)
                                
                            }
                        }
                    }
                default: EmptyView()
            }
        }
    }
}
