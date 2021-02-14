//
//  SourceAttribution.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-13.
//

import SwiftUI

struct SourceAttribution: View {
    private let sourceURL = URL(string: "https://smhi.se")!
    
    #if os(watchOS)
    typealias Stack = VStack
    #else
    typealias Stack = HStack
    #endif
    
    var scale: CGFloat = {
        #if os(watchOS)
        return 0.8
        #else
        return 1.0
        #endif
    }()
    
    var body: some View {
        Stack(spacing: 4) {
            Spacer()
            Text("Source")
            Link("SMHI", destination: sourceURL)
                .scaleEffect(scale)
            Spacer()
        }
    }
}

struct Attribution_Previews: PreviewProvider {
    static var previews: some View {
        SourceAttribution()
    }
}
