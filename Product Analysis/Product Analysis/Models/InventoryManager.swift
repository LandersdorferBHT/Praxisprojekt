//
//  InventoryManager.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 12.02.25.
//

import Foundation

class InventoryManager {
    private var products: [Product]
    
    // Initializes the 'InventoryManager' with a given list of products
    init(products: [Product]) {
        self.products = products
    }
    
    // Return all avaialable products
    func getAllProducts() -> [Product] {
        return products
    }
    
    // Returns a sorted list of all unique product categories
    func getCategories() -> [String] {
        let categories = Set(products.map { $0.category })
        
        return categories.sorted()
    }
    
    // Returns the total number of unsold products in stock
    func getStockCount() -> Int {
        let count = products.filter { $0.salesDate == nil }.count
        return count
    }
    
    // Returns the count of new and old stock within the last 30 days
    func getStockAge() -> (newStockCount: Int, oldStockCount: Int) {
        let now = Date()
        let thresholdDate = Calendar.current.date(byAdding: .day, value: -30, to: now)!
        
        let newStockCount = products.filter { $0.salesDate == nil && $0.stockDate >= thresholdDate }.count
        let oldStockCount = products.filter { $0.salesDate == nil && $0.stockDate < thresholdDate }.count
        
        return (newStockCount, oldStockCount)
    }
    
    
    // Returns the number of products that have been in stock for more than 30 days
    func getOldStockCount() -> Int {
        let thresholdDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        return products.filter {
            $0.salesDate == nil && ($0.stockDate) < thresholdDate
        }.count
    }
    
    // Calculated the average stock duration
    func getAverageStockDuration() -> Int {
        let stockDurations = products.compactMap { product -> Int? in
            guard let salesDate = product.salesDate else { return nil }
            return Calendar.current.dateComponents([.day], from: product.stockDate, to: salesDate).day
        }
        
        guard !stockDurations.isEmpty else { return 0 }
        return stockDurations.reduce(0, +) / stockDurations.count
    }
    
    // Returns the number of unique product categories
    func getCategoryCount() -> Int {
        let uniqueCategories = Set(products.map { $0.category })
        return uniqueCategories.count
    }
    
    // Returns the most store category based on stock count
    func getMostStoredCategory() -> String {
        let categoryStockCount = Dictionary(grouping: products.filter { $0.salesDate == nil }, by: { $0.category })
            .mapValues { $0.count }
        
        return categoryStockCount.max { $0.value < $1.value }?.key ?? "Unbekannt"
    }
    
    // Returns the top 5 best-selling products
    func getTopSales() -> [(name: String, count: Int)] {
        let soldProducts = products.filter { $0.salesDate != nil }
        let salesCount = Dictionary(grouping: soldProducts, by: { $0.name })
            .mapValues { $0.count }
        
        return salesCount.sorted { $0.value > $1.value }
            .prefix(5)
            .map { ($0.key, $0.value) }
    }
    
    // Returns the 5 worst-selling products
    func getLowSales() -> [(name: String, count: Int)] {
        let soldProducts = products.filter { $0.salesDate != nil }
        let salesCount = Dictionary(grouping: soldProducts, by: { $0.name })
            .mapValues { $0.count }
        
        return salesCount.sorted { $0.value < $1.value }
            .prefix(5)
            .map { ($0.key, $0.value) }
    }
    
    // Returns sales data grouped by category
    func getCategorySales() -> [(category: String, count: Int)] {
        let salesByCategory = Dictionary(grouping: products.filter { $0.salesDate != nil }, by: { $0.category })
            .mapValues { $0.count }
        
        return salesByCategory.sorted { $0.value > $1.value }
            .map { (category: $0.key, count: $0.value) } // Umwandlung in das erwartete Format
    }
    
    // Returns sales data grouped by product color
    func getColorSales() -> [(color: String, count: Int)] {
        let salesByColor = Dictionary(grouping: products.filter{ $0.salesDate != nil }, by: { $0.color })
            .mapValues { $0.count }
                
        return salesByColor.sorted { $0.value > $1.value }
            .map{ (color: $0.key, count: $0.value) }
    }
    
    
    // Calculated sales trends over a given period 
        func getSalesTrend(period: Int) -> [Date: Int] {
            let sales = products.compactMap { product -> (Date, Int)? in
                guard let salesDate = product.salesDate else { return nil }
                return (salesDate, 1)
            }
        
            let salesByDate = Dictionary(grouping: sales, by: { $0.0 })
                .mapValues { $0.count }
        
            let recentSales = salesByDate.filter { $0.key >= Calendar.current.date(byAdding: .day, value: -period, to: Date())! }
    
            return recentSales
        }
    }


