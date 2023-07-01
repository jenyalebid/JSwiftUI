//
//  IconListItemView.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 6/30/23.
//

import SwiftUI

public struct IconListItemBlock<Content: View>: View {
    
    var content: Content
    var imageName: String
    
    public init(imageName: String, @ViewBuilder content: () -> Content) {
        self.imageName = imageName
        self.content = content()
    }
    
    public var body: some View {
        HStack {
            Group {
                Image(systemName: imageName)
                    .frame(width: 16, alignment: .center)
                Divider()
                    .padding(.trailing, 4)
            }
            content
        }
    }
}

private struct IconListItemBlock_Previews: PreviewProvider {
    static var previews: some View {
        IconListItemBlock(imageName: "circle.fill") {
            
        }
    }
}
