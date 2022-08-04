//
//  ContentView.swift
//  Pedometer Connect
//
//  Created by Jackson Crawford on 6/06/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PedometerViewModel()
    
    var body: some View {
        if viewModel.connected {
            HStack{
                VStack {
                    ChartView(viewModel: viewModel)
                        .padding(.bottom,50)
                        .padding(.top,250)
                    
                    Text("Metres walked today: \(viewModel.metresToday)")
                        .font(.title.bold())
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16.0)
                        .padding(.bottom)
                        .frame(alignment: .leading)
                    
                    Text("Metres walked this hour: \(viewModel.metresLastHour)")
                        .font(.title.bold())
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(16.0)
                        .padding(.bottom)
                        .frame(alignment: .leading)
                    
                    
                    ConnectButtonView(viewModel: viewModel)
                }
            }
        } else if viewModel.buttonTapped && !viewModel.connected {
            VStack {
                Text(viewModel.output)
                    .font(.largeTitle.bold())
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(16.0)
                    .padding(.bottom)
                
                Text("If this takes more than a few seconds, move your walker forwards or back until the red light starts flashing")
                    .font(.body.italic().bold())
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(16.0)
                    .padding(.bottom)
                
                Button(action: {
                    viewModel.clearData()
                }, label: {
                    Text("CLEAR DATA")
                        .padding()
                        .frame(height: 70, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.red)
                        .cornerRadius(16.0)
                        .shadow(color: Color.gray, radius: 3.0, y: 3.0)
                        .font(.system(size: 12, weight: .bold))
                        .padding()
                })
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
