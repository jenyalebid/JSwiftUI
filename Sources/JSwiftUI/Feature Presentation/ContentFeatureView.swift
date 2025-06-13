//
//  ContentFeatureView.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 6/10/25.
//

import SwiftUI

struct ContentFeatureView: View {
    
    var image: ImageResource?
    var systemImage: String?
    var title: String
    var description: Text
    
    var body: some View {
        HStack(spacing: 0) {
            Group {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.largeTitle)
                        .imageScale(.large)
                }
                else if let image {
                    Image(image)
                }
            }
            .frame(width: 80)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                description
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentFeatureView(systemImage: "star", title: "Feature Title", description: Text("Feature description goes here to stay."))
}
