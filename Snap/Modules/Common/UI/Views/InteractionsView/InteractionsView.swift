//
//  InteractionsView.swift
//  Snap
//
//  Created by Gordon Smith on 21/03/2021.
//

import Foundation
import SwiftUI

struct InteractionsView: View {
    
    private let likes: Int
    
    init(likes: Int) {
        self.likes = likes
    }
    
    var body: some View {
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
}
