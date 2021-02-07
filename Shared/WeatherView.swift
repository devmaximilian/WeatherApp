//
//  WeatherView.swift
//  Shared
//
//  Created by Maximilian Wendel on 2021-02-07.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var model: WeatherModel
    
    private let sourceURL = URL(string: "https://smhi.se")!
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(systemName: model.symbol)
                    .font(
                        .system(
                            size: 36,
                            weight: .bold,
                            design: .serif
                        )
                    )
                Text("\(model.temperature) °C")
                    .font(
                        .system(
                            size: 36,
                            weight: .bold,
                            design: .serif
                        )
                    )
                
            }
            HStack(spacing: 4) {
                Text("Source:")
                Link("SMHI", destination: sourceURL)
            }
        }
        .frame(
            width: 350,
            height: 150,
            alignment: .center
        )
        .padding(10)
        .onAppear(
            perform: model.update
        )
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
