//
//  CategorySalesChartView.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 15.02.25.
//

import SwiftUI
import Charts

struct ColorSalesChartView: View {
    var salesData: [(color: String, count: Int)]
    
    var body: some View {
        VStack {
            Chart {
                // Loop through the top 5 color sales data
                ForEach(salesData.prefix(5), id: \.color) { data in
                    BarMark(
                        x: .value("Farbe", data.color),
                        y: .value("Verkäufe", data.count)
                    )
                    .foregroundStyle(.blue)
                    
                    // Displays sales count above each bar
                    PointMark(
                        x: .value("Farbe", data.color),
                        y: .value("Verkäufe", data.count)
                    )
                    .annotation(position: .top) {
                        Text("\(data.count)")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
            }
            //Adjust chart height dynamically based on data size
            .frame(height: salesData.count > 5 ? 300 : 200)
            
            // Customize the X-axis labels for better readability
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let color = value.as(String.self) {
                            Text(color)
                                .multilineTextAlignment(.center)
                                .lineLimit(5)
                                .frame(width: 60)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}
