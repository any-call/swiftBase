//
//  sheetLink.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/13.
//

extension myUI {
    
    public struct SheetLink<Label: View, Destination: View>: View {
        
        @State private var show = false
        
        let destination: () -> Destination
        let label: () -> Label
        
        public init(
            @ViewBuilder destination: @escaping () -> Destination,
            @ViewBuilder label: @escaping () -> Label
        ) {
            self.destination = destination
            self.label = label
        }
        
        public var body: some View {
            
            Button {
                show = true
            } label: {
                label()
            }
            .sheet(isPresented: $show) {
                destination()
            }
            
        }
        
    }
    
}
