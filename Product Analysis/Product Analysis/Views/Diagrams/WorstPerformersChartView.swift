//
//  WorstPerformersChartView.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 15.02.25.
//

import SwiftUI

struct WorstPerformersChartView: View {
    var salesData: [(name: String, count: Int)]
    
    var body: some View {
        VStack {
            // Displays the sales data in a list format
            List(salesData, id: \.name) { product in
                HStack {
                    Text(product.name)
                    Spacer()
                    Text("\(product.count) Verkäufe")
                        .foregroundColor(.black)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}
