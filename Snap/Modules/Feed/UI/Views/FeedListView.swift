//
//  FeedListView.swift
//  Snap
//
//  Created by Gordon Smith on 19/03/2021.
//

import Foundation
import SwiftUI

struct FeedListView: View {
    
    @ObservedObject private(set) var viewModel: FeedViewModel
    
    var body: some View {
        
        renderViewFor(viewModel.state)
            .onAppear(perform: viewModel.loadFeed)
            .padding()
    }
}

private extension FeedListView {
    func renderViewFor(_ state: ViewState<[Post]>) -> some View  {
        return Group {
            
            if case .loading = state {
                LoadingView()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color("3dc6a7"))
            }
            
            if case let .loaded(feed) = state {
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(spacing: 0) {
                        ForEach(feed, id: \.id) { item in
                            Text("Post \(item.id)")
                        }
                    }
                }
            }
            
        }
    }
}
