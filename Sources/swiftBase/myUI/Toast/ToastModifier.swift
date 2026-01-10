//
//  ToastModifier.swift
//  swiftBase
//
//  Created by jinguihua on 2026/1/9.
//


import SwiftUI

struct ToastModifier: ViewModifier {

    @Binding var toast: ToastState?

    func body(content: Content) -> some View {
        ZStack {
            content

            if let toast {
                toastContainer(toast)
                    .transition(.opacity.combined(with: moveTransition(for: toast.position)))
                    .onAppear {
                        scheduleDismissIfNeeded(toast)
                    }
            }
        }
        .animation(.easeInOut, value: toast)
    }

    // MARK: - Toast 容器（控制位置）

    @ViewBuilder
    private func toastContainer(_ toast: ToastState) -> some View {
        VStack {
            if toast.position == .bottom { Spacer() }

            ToastView(toast: toast)
                .padding(.horizontal, 20)
                .padding(verticalPadding(for: toast.position))

            if toast.position == .top { Spacer() }
        }
        .allowsHitTesting(false)
    }

    private func verticalPadding(for position: ToastState.Position) -> EdgeInsets {
        switch position {
        case .top:
            return EdgeInsets(top: 44, leading: 0, bottom: 0, trailing: 0)
        case .center:
            return EdgeInsets()
        case .bottom:
            return EdgeInsets(top: 0, leading: 0, bottom: 44, trailing: 0)
        }
    }

    // MARK: - 自动消失

    private func scheduleDismissIfNeeded(_ toast: ToastState) {
        guard let duration = toast.duration else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                self.toast = nil
            }
        }
    }

    // MARK: - 动画

    private func moveTransition(
        for position: ToastState.Position
    ) -> AnyTransition {
        switch position {
        case .top:
            return .move(edge: .top)
        case .center:
            return .scale
        case .bottom:
            return .move(edge: .bottom)
        }
    }
}