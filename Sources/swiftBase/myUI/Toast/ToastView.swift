//
//  ToastView.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/9.
//


import SwiftUI

struct ToastView: View {

    let toast: ToastState

    var body: some View {
        Text(toast.message)
            .font(.system(size: 14))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 8)
    }

    private var backgroundColor: Color {
        switch toast.style {
        case .normal:
            return Color.black.opacity(0.85)
        case .success:
            return Color.green.opacity(0.85)
        case .error:
            return Color.red.opacity(0.85)
        case .warning:
            return Color.orange.opacity(0.85)
        }
    }
}