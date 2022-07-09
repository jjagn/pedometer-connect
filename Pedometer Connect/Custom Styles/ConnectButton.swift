//
//  ConnectButton.swift
//  Pedometer Connect
//
//  Created by Jackson Crawford on 1/07/22.
//

import SwiftUI

struct ConnectButton: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 70, alignment: .center)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(16.0)
            .shadow(color: Color.gray, radius: 3.0, y: 3.0)
            .font(.system(size: 18, weight: .bold))
            .onTapGesture {

            }
    }
}

struct ConnectButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Button(action: {}) { Text("Connect") }
                .buttonStyle(ConnectButton())
        }
    }
}
