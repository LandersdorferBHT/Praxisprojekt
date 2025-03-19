//
//  StockAgeChartView.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 15.02.25.
//

import SwiftUI
import Charts

struct StockAgeChartView: View {
    var newStockCount: Int
    var oldStockCount: Int
    
    var body: some View {
        VStack {
            Chart {
                BarMark(x: .value("Neu", "Neu"), y: .value("Anzahl", newStockCount))
                    .foregroundStyle(.blue)
                
                BarMark(x: .value("Alt", "Alt"), y: .value("Anzahl", oldStockCount))
                    .foregroundStyle(oldStockCount > 10 ? .red : .gray)
                
                // Display value above the new stock bar
                PointMark(x: .value("Neu", "Neu"), y: .value("Anzahl", newStockCount))
                    .annotation(position: .top) {
                        Text("\(newStockCount)")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                
                // Display value above the old stock bar
                PointMark(x: .value("Alt", "Alt"), y: .value("Anzahl", oldStockCount))
                    .annotation(position: .top) {
                        Text("\(oldStockCount)")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

