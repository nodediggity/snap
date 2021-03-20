//
//  Shimmer+ViewModifier.swift
//  Snap
//
//  Created by Gordon Smith on 20/03/2021.
//

import Foundation
import SwiftUI

struct Shimmer: ViewModifier {
    
    @State private var startPoint: UnitPoint = UnitPoint(x: -1, y: 0.5)
    @State private var endPoint: UnitPoint = .bottomLeading
    
    func body(content: Content) -> some View {
        ZStack() {
            content
            LinearGradient(
                gradient: gradient,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .onAppear {
                let animation = Animation.linear(duration: 1.25)
                withAnimation(animation.repeatForever(autoreverses: false)) {
                    startPoint = .topTrailing
                    endPoint = UnitPoint(x: 2, y: 0.5)
                }
            }
        }
    }
}

private extension Shimmer {
    var gradient: Gradient {
        let alpha = UIColor.white.withAlphaComponent(0.75).cgColor
        let white = UIColor.white.cgColor
        let gradient = Gradient(stops: [
            .init(color: Color(alpha), location: 0.4),
            .init(color: Color(white), location: 0.5),
            .init(color: Color(alpha), location: 0.6)
        ])
        return gradient
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(Shimmer())
    }
}
