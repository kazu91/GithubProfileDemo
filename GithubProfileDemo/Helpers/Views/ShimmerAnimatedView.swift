//
//  ShimmerAnimatedView.swift
//  GithubProfileDemo
//
//  Created by Kazu on 23/9/24.
//

import Foundation

import SwiftUI

struct ShimmerAnimatedView:View {
    
    private var gradient = Gradient(stops: [
        .init(color: .white.opacity(0.4), location: 0),
        .init(color: .white, location: 0.5),
        .init(color: .white.opacity(0.4), location: 1)
    ])
    
    @State var startPoint: UnitPoint = .init(x: -1, y: 0)
    @State var endPoint: UnitPoint = .init(x: 0, y: 0)
    
    var body: some View {
        LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
            .onAppear {
                withAnimation(.easeIn(duration: 1.5).repeatForever(autoreverses: false)) {
                    startPoint = .init(x: 1.5, y: 0)
                    endPoint = .init(x: 2, y: 0)
                }
            }
    }
    
}

#Preview {
    ShimmerAnimatedView()
}
