//
//  FeedCardFooterView.swift
//  Snap
//
//  Created by Gordon Smith on 21/03/2021.
//

import Foundation
import SwiftUI

struct FeedCardFooterView: View {
    
    private let name: String
    private let likes: Int
    
    init(name: String, likes: Int) {
        self.name = name
        self.likes = likes
    }
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(Color(.label))
                .font(.body)
                .offset(x: 56)
            Spacer()
            InteractionsView(likes: likes)
        }
        .padding()
    }
}
