//
//  Temperature.swift
//  WeatherApp (iOS)
//
//  Created by Maximilian Wendel on 2021-07-04.
//

import SwiftUI

struct CurrentConditions: View {
    let titleFont: Font = {
        let font = UIFont.systemFont(ofSize: 108.0, weight: .thin)
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        return Font(fontMetrics.scaledFont(for: font))
    }()
    
    let subtitleFont: Font = {
        let font = UIFont.systemFont(ofSize: 31.0, weight: .regular)
        let fontMetrics = UIFontMetrics(forTextStyle: .title1)
        return Font(fontMetrics.scaledFont(for: font))
    }()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Text("Stockholm")
                    .font(subtitleFont)
                Text("Soligt")
                    .font(.callout)
                Text("26°")
                    .font(titleFont)
                    .offset(x: 15, y: 0)
            }
            .frame(
                maxWidth: .infinity,
                minHeight: geometry.size.height * 0.4
            )
        }
    }
}

struct CurrentConditions_Preview: PreviewProvider {
    static var previews: some View {
        CurrentConditions()
    }
}
