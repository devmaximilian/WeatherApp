//
//  SourceAttribution.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-13.
//

import SwiftUI

struct SourceAttribution: View {
    private let sourceURL = URL(string: "https://smhi.se")!
    
    var body: some View {
        HStack(spacing: 4) {
            Spacer()
            Text("Source:")
            Link("SMHI", destination: sourceURL)
            Spacer()
        }
    }
}

struct Attribution_Previews: PreviewProvider {
    static var previews: some View {
        SourceAttribution()
    }
}
