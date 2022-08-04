//
//  ChartView.swift
//  Pedometer Connect
//
//  Created by Jackson Crawford on 2/07/22.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    
    let demoData: [Double] = [55, 47, 43, 45, 40, 67, 68, 64, 67, 73, 72]
    
    @ObservedObject var viewModel: PedometerViewModel
    
    let style: ChartStyle = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Colors.OrangeStart,
        secondGradientColor: Colors.OrangeEnd,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    var body: some View {
        GeometryReader { geometry in
            LineChartView(data: viewModel.stepsDataOverTime.map {$0 / 5}, title: "Distance over time", style: style, form: CGSize(width: geometry.size.width-100, height: 240), rateValue: viewModel.changeRate, dropShadow: true)
                .frame(width: geometry.size.width, height: 240, alignment: .center)
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var viewModel  = PedometerViewModel()
    static var previews: some View {
        ChartView(viewModel: viewModel)
    }
}
