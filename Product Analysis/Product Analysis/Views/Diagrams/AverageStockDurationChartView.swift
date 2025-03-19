//
//  AverageStockDurationChartView.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 15.02.25.
//

import SwiftUI
import Charts

struct AverageStockDurationChartView: View {
    var averageDays: Int
    
    var body: some View {
        VStack {
            // Display the average stock duration with conditional formatting
            Text("\(averageDays) Tage")
                .font(.title2)
                .bold()
                .foregroundColor(averageDays > 30 ? .red : .green)
        }
        // Expand to full width
        .frame(maxWidth: .infinity)
        
        // Set background color to white
        .background(Color.white)
    }
}
