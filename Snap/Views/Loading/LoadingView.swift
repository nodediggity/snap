//
//  LoadingView.swift
//  Snap
//
//  Created by Gordon Smith on 19/03/2021.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    
    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        let animation = Animation
            .easeOut(duration: 1.25)
            .repeatForever(autoreverses: false)
        
        Circle()
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                scale = 0
                opacity = 1
                withAnimation(animation) {
                    scale = 1
                    opacity = 0
                }
            }
    }
}
