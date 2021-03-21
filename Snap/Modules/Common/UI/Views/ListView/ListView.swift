//
//  ListView.swift
//  Snap
//
//  Created by Gordon Smith on 21/03/2021.
//

import Foundation
import SwiftUI

struct ListView<Content, T>: View where Content: View, T: Identifiable {
    
    private var items: [T]
    private var content: (T) -> Content
    
    init(items: [T], @ViewBuilder _ content: @escaping (T) -> Content) {
        self.items = items
        self.content = content
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 0) {
                ForEach(items, id: \.id) { item in
                    content(item)
                }
            }
            .background(Color(.systemBackground))
        }
    }
}
