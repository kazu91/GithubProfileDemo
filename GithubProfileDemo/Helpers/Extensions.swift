//
//  Extensions.swift
//  GithubProfileDemo
//
//  Created by Kazu on 23/9/24.
//

import Foundation
import SwiftUI

///
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//MARK: - SwiftUI View
extension View {
    public func borderRadius<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat, corners: UIRectCorner) -> some View where S : ShapeStyle {
        let roundedRect = RoundedCorner(radius: cornerRadius, corners: corners)
        return clipShape(roundedRect)
            .overlay(roundedRect.stroke(content, lineWidth: width))
    }
}
//MARK: - Int
extension Int {
    var formattedWithK: String {
        if self >= 1000 {
            let formattedNumber = Double(self) / 1000.0
            return String(format: "%.0fk", formattedNumber)
        } else {
            return String(self)
        }
    }
}
