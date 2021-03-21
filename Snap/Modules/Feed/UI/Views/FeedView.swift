//
//  FeedView.swift
//  Snap
//
//  Created by Gordon Smith on 19/03/2021.
//

import Foundation
import SwiftUI

struct FeedView: View {
    
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
                    
                    ListView(items: feed) { item in
                        FeedCard(item: item)
                    }
                    
                default: EmptyView()
            }
        }
    }
}
