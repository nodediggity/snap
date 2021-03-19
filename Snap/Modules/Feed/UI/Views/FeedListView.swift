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
        ScrollView(.vertical, showsIndicators: false) {
            if viewModel.isLoading {
                LoadingView()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color("3dc6a7"))
            } else {
                ForEach(viewModel.feed, id: \.id) { item in
                    Text("Post \(item.id)")
                }
            }
        }
        .onAppear(perform: viewModel.loadFeed)
        .padding()
    }
}
