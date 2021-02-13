//
//  MetricView.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-08.
//

import SwiftUI

struct MetricView: View {
    let metric: Metric
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: geometry.size.height * 0.12) {
                Circle()
                    .foregroundColor(Color.accentColor.opacity(0.05))
                    .frame(width: geometry.size.height * 0.65, height: geometry.size.height * 0.65, alignment: .center)
                    .overlay(
                        Image(systemName: metric.systemName)
                            .font(
                                .system(
                                    size: geometry.size.height * 0.35,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
                            .foregroundColor(.accentColor),
                        alignment: .center
                    )
                
                VStack(alignment: .leading, spacing: geometry.size.height * -0.03) {
                    Text(metric.name)
                        .font(
                            .system(
                                size: geometry.size.height * 0.21,
                                weight: .light,
                                design: .default
                            )
                        )
                    HStack(alignment: .firstTextBaseline, spacing: geometry.size.height * 0.04) {
                        Text(metric.displayValue)
                            .font(
                                .system(
                                    size: geometry.size.height * 0.30,
                                    weight: .regular,
                                    design: .rounded
                                )
                            )
                        Text(metric.unit)
                            .font(
                                .system(
                                    size: geometry.size.height * 0.22,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
                    }
                    .foregroundColor(.accentColor)
                }
                Spacer()
            }
            .padding(.horizontal, geometry.size.height * 0.1)
            .padding(.vertical, geometry.size.height * 0.15)
            .background(Color.secondary.opacity(0.12))
            .cornerRadius(geometry.size.height * 0.1)
        }
        
    }
}

struct MetricView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MetricView(metric: .preview)
            .accentColor(Color.blue)
            .frame(width: 350, height: 150, alignment: .center)
        }
        .padding()
    }
}
