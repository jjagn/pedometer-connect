//
//  ContentView.swift
//  Pedometer Connect
//
//  Created by Jackson Crawford on 6/06/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = PedometerViewModel()
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            if viewModel.connected {
                VStack {
                    ChartView(viewModel: viewModel)
                        .padding(.bottom,50)
                        
                    Text("Steps today: \(viewModel.stepsTotal)")
                        .font(.title.bold())
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16.0)
                        .padding(.bottom)
                        .frame(alignment: .leading)

                    Text("Steps this hour: \(viewModel.output)")
                        .font(.title.bold())
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16.0)
                        .padding(.bottom)
                        .frame(alignment: .leading)

                        
                    ConnectButtonView(viewModel: viewModel)
                }
            } else {
                VStack {
                    Text(viewModel.output)
                        .font(.title.bold())
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16.0)
                        .padding(.bottom)
                    
                    ConnectButtonView(viewModel: viewModel)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
