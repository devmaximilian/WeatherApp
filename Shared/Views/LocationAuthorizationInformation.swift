//
//  LocationAuthorizationInformation.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-02-13.
//

import SwiftUI

#if os(watchOS)
typealias BorderlessButtonStyle = PlainButtonStyle
#endif

struct LocationAuthorizationInformation: View {
    private var action: (() -> Void)?
    private var dismissAction: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil, dismiss dismissAction: (() -> Void)? = nil) {
        self.action = action
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 5) {
                Text("Location authorization")
                    .font(.headline)
                Text("Alternatively, you can set location information manually in the settings.")
                HStack {
                    Spacer()
                    Button("Allow Location Usage", action: action ?? {})
                        .buttonStyle(AuthorizationButtonStyle())
                    Spacer()
                }
                .padding(.top, 10)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .overlay(
                Button(action: dismissAction ?? {}) {
                    Image(systemName: "xmark")
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(5),
                alignment: .topTrailing
            )
        }
    }
}

struct AuthorizationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let label = configuration.label
            .font(Font.callout.weight(.medium))
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(configuration.isPressed ? Color.blue.opacity(0.85) : Color.blue)
            .cornerRadius(8)
            .foregroundColor(.white)
        #if os(watchOS)
        return label
            .scaleEffect(0.8)
        #else
        return label
        #endif
    }
}

struct LocationAuthorizationInformation_Previews: PreviewProvider {
    static var previews: some View {
        LocationAuthorizationInformation()
    }
}
