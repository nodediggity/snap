//
//  AsyncImageView.swift
//  Snap
//
//  Created by Gordon Smith on 20/03/2021.
//

import UIKit
import SwiftUI

struct AsyncImageView: View {
    
    typealias ViewModel = AsyncImageViewModel<UIImage>
    
    @ObservedObject private var viewModel: ViewModel
    
    private var canRetry: Bool
    
    init(viewModel: ViewModel, canRetry: Bool = true) {
        self.viewModel = viewModel
        self.canRetry = canRetry
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
                case .loading:
                    Color(.tertiarySystemFill)
                        // .shimmer() - This modifier seems to be causing a 40 - 50 mb spike in memory usage...
                        .onAppear(perform: viewModel.loadImage)
                case let .loaded(image):
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .error where canRetry:
                    Text("oops.")
                default:
                    EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .onDisappear(perform: viewModel.cancel)
    }
}
