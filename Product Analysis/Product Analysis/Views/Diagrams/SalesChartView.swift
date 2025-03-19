//
//  SwiftUIView.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 10.02.25.
//

import SwiftUI
import Charts

struct SalesChartView: View {
    var salesData: [(name: String, count: Int)]
    var chartTitle: String
    
    var body: some View {
        VStack {
            Chart {
                // Create a bar chart for each sales data entry
                ForEach(salesData, id: \.name) { data in
                    BarMark(
                        x: .value("Gerät", data.name),
                        y: .value("Verkäufe", data.count)
                    )
                    .foregroundStyle(.blue)
                    
                    // Display the sales count above each bar
                    PointMark(
                        x: .value("Gerät", data.name),
                        y: .value("Verkäufe", data.count)
                    )
                    .annotation(position: .top) {
                        Text("\(data.count)")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
            }
            // Adjust chart height dynamically bases on data size
            .frame(height: salesData.count > 5 ? 300 : 200)
            
            // Customize X-axis labels for better readability
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let color = value.as(String.self) {
                            Text(color)
                                .multilineTextAlignment(.center)
                                .lineLimit(5)
                                .frame(width: 60)
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








