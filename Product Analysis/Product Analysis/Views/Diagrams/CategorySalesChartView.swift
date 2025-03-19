//
//  CategorySalesChartView.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 15.02.25.
//

import SwiftUI
import Charts

struct CategorySalesChartView: View {
    var salesData: [(category: String, count: Int)]
    
    var body: some View {
        VStack {
            // Create a bar chart displaying sales per category
            Chart {
                ForEach(salesData, id: \.category) { data in
                    BarMark(
                        x: .value("Kategorie", data.category),
                        y: .value("Verkäufe", data.count)
                    )
                    .foregroundStyle(.blue)
                    
                    // Display sales count as a label above each bar
                    PointMark(
                        x: .value("Kategorie", data.category),
                        y: .value("Verkäufe", data.count)
                    )
                    .annotation(position: .top) {
                        Text("\(data.count)")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
            }
            // Adjust chart height dynamically based on the number of categories
            .frame(height: salesData.count > 5 ? 300 : 200)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}
