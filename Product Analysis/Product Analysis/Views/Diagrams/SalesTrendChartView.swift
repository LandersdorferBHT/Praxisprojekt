//
//  SalesTrendChartView.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 15.02.25.
//

import SwiftUI
import Charts

struct SalesTrendChartView: View {
    var salesData: [Date: Int]
    var selectedPeriod: Int
    
    var body: some View {
        VStack {
            // Create a line chart with data sorted by date
            Chart(salesData.sorted(by: { $0.key < $1.key }), id: \.key) {
                LineMark(
                    x: .value("Datum", $0.key),
                    y: .value("Verkäufe", $0.value)
                )
                .foregroundStyle(.blue)
                
                // Add points to the line chart for better visibility
                PointMark(
                    x: .value("Datum", $0.key),
                    y: .value("Verkäufe", $0.value)
                )
            }
            .frame(height: 200)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}
