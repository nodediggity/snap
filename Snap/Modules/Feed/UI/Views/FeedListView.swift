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
    @State private var isLoading: Bool = false
    @State private var items: [Post] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if isLoading {
                LoadingView()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color("3dc6a7"))
            } else {
                ForEach(items, id: \.id) { item in
                    Text("Post \(item.id)")
                }
            }
        }
        .onAppear(perform: onLoad)
        .padding()
    }
}

private extension FeedListView {
    
    func onLoad() {
        viewModel.onLoadingStateChange = { self.isLoading = $0 }
        viewModel.onFeedLoad = { self.items = $0 }
        
        viewModel.loadFeed()
    }
}
