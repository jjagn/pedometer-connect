//
//  ChartView.swift
//  Pedometer Connect
//
//  Created by Jackson Crawford on 2/07/22.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    
    @ObservedObject var viewModel: PedometerViewModel
    
    var body: some View {
        LineChartView(data: viewModel.stepsDataOverTime, title: "Steps", form: ChartForm.extraLarge, rateValue: viewModel.changeRate, dropShadow: true)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var viewModel  = PedometerViewModel()
    static var previews: some View {
        ChartView(viewModel: viewModel)
    }
}
