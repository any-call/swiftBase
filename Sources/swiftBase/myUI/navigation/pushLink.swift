//
//  pushLink.swift
//  swiftBase
//
//  Created by jinguihua on 2026/3/13.
//

extension myUI {
    
    public struct PushLink<Item, Label: View, Destination: View>: View {
        
        let item: Item?
        let destination: (Item) -> Destination
        let label: () -> Label
        
        public init(
            item: Item?,
            @ViewBuilder destination: @escaping (Item) -> Destination,
            @ViewBuilder label: @escaping () -> Label
        ) {
            self.item = item
            self.destination = destination
            self.label = label
        }
        
        public var body: some View {
            
            if let value = item {
                
                NavigationLink {
                    destination(value)
                } label: {
                    label()
                }
                
            } else {
                
                label()
                
            }
            
        }
        
    }
    
}


extension myUI.PushLink where Item == Bool {
    
    public init(
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        
        self.item = true
        self.destination = { _ in destination() }
        self.label = label
        
    }
    
}
