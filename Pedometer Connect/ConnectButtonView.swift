//
//  ConnectButtonView.swift
//  Pedometer Connect
//
//  Created by Jackson Crawford on 30/06/22.
//

import SwiftUI

struct ConnectButtonView: View {
    @ObservedObject var viewModel: PedometerViewModel
    
    @State private var buttonState:Bool = false
    
    var body: some View {
        HStack {
            if viewModel.connected {
                Button(action: {
                    viewModel.disconnectPedometer()
                }, label: {
                    Text("Disconnect")
                        .padding()
                        .frame(height: 70, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16.0)
                        .shadow(color: Color.gray, radius: 3.0, y: 3.0)
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                })
            } else {
                Button(action: {
                    viewModel.connectPedometer()
                }, label: {
                    Text("Connect")
                        .padding()
                        .frame(height: 70, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16.0)
                        .shadow(color: Color.gray, radius: 3.0, y: 3.0)
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                })
            }
        }
        .frame(width: 220)
        .padding(.top)
    }
}

struct ConnectButtonView_Previews: PreviewProvider {
    static var viewmodel  = PedometerViewModel()
    static var previews: some View {
        ConnectButtonView(viewModel: viewmodel)
    }
}
