import SwiftUI

public extension View {

    func myToast(_ toast: Binding<ToastState?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
