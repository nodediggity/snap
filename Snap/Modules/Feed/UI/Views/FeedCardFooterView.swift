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
            HStack {
                Image("heart_icon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color(.label))
                    .frame(width: 18, height: 18)
                Text("\(likes)")
                    .foregroundColor(Color(.label))
                    .font(.footnote)
                
                Image("bookmark_icon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color(.label))
                    .frame(width: 18, height: 18)
            }
        }
        .padding()
    }
}
