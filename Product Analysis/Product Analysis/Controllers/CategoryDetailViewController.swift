//
//  CategoryDetailViewController.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 05.03.25.
//

import UIKit

class CategoryDetailViewController: UITableViewController {
    
    public var categorizedProducts: [Product] = []
    
    // Arrays for seperating products into 'in-stock' and 'sold'
    private var inStockProducts: [Product] = []
    private var soldProducts: [Product] = []
    
    // Dictionaries to store products grouped by color and storage capacity
    private var inStockData: [String: [String: [Product]]] = [:]
    private var soldData: [String: [String: [Product]]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CategoryDetailVC Loaded.")
        print("Products: \(categorizedProducts)")
        
        if let firstProduct = categorizedProducts.first {
            self.title = firstProduct.name
        }
        
        // Split products
        inStockProducts = categorizedProducts.filter { $0.salesDate == nil }
        soldProducts = categorizedProducts.filter { $0.salesDate != nil }
        
        categorizeProducts()
        
        tableView.register(ProductDetailCell.self, forCellReuseIdentifier: "ProductDetailCell")
    }
    
    // Group products by color and storage capacity
    func categorizeProducts() {
        for product in categorizedProducts {
            if product.salesDate == nil {
                inStockData[product.color, default: [:]][product.storage, default: []].append(product)
            } else {
                soldData[product.color, default: [:]][product.storage, default: []].append(product)
            }
        }
    }
    
    /// MARK: - TableView DataSource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return inStockData.count + soldData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < inStockData.count {
            let colorKey = Array(inStockData.keys)[section]
            if let colorData = inStockData[colorKey] {
                return colorData.keys.count
            }
            return 0
            
        } else {
            let soldColorKey = Array(soldData.keys)[section - inStockData.count]
            if let soldColorData = soldData[soldColorKey] {
                return soldColorData.keys.count
            }
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < inStockData.count {
            let colorKey = Array(inStockData.keys)[section]
            return colorKey
        } else {
            let soldColorKey = Array(soldData.keys)[section - inStockData.count]
            return soldColorKey
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailCell", for: indexPath) as! ProductDetailCell
        cell.selectionStyle = .none
        
        if indexPath.section < inStockData.count {
            
            // Handling in-stock products
            let colorKey = Array(inStockData.keys)[indexPath.section]
            if let colorData = inStockData[colorKey] {
                
                // Sort storage sizes in ascending order (from small to large)
                let storageKeys = (colorData.keys).sorted { key1, key2 in
                    let trimmed1 = key1.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    let trimmed2 = key2.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

                    if trimmed1 == "2tb" { return false }
                    if trimmed2 == "2tb" { return true }
                    if trimmed1 == "1tb" { return false }
                    if trimmed2 == "1tb" { return true }

                    let numberString1 = trimmed1.replacingOccurrences(of: "gb", with: "")
                    let numberString2 = trimmed2.replacingOccurrences(of: "gb", with: "")

                    let num1 = Int(numberString1) ?? 0
                    let num2 = Int(numberString2) ?? 0
                    return num1 < num2
                }

                
                if storageKeys.isEmpty {
                    return UITableViewCell() // Fallback, falls keine Produkte vorhanden sind
                }
                
                let storageKey = storageKeys[indexPath.row]
                let inStockProducts = colorData[storageKey] ?? []
                let soldProducts = soldData[colorKey]?[storageKey] ?? []
                
                let stockCount = inStockProducts.count
                let soldCount = soldProducts.count
                
                cell.configure(with: storageKey, stockCount: stockCount, soldCount: soldCount)
            }
        } else {
            
            // Handling sold products
            let soldColorKey = Array(soldData.keys)[indexPath.section - inStockData.count]
            if let soldColorData = soldData[soldColorKey] {
                
                // Sort storage sizes in ascending order (from small to large)
                let soldStorageKeys = (soldColorData.keys).sorted { key1, key2 in
                    let trimmed1 = key1.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    let trimmed2 = key2.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

                    if trimmed1 == "2tb" { return false }
                    if trimmed2 == "2tb" { return true }
                    if trimmed1 == "1tb" { return false }
                    if trimmed2 == "1tb" { return true }

                    let numberString1 = trimmed1.replacingOccurrences(of: "gb", with: "")
                    let numberString2 = trimmed2.replacingOccurrences(of: "gb", with: "")

                    let num1 = Int(numberString1) ?? 0
                    let num2 = Int(numberString2) ?? 0
                    return num1 < num2
                }
                
                if soldStorageKeys.isEmpty {
                    return UITableViewCell()
                }
                
                let soldStorageKey = soldStorageKeys[indexPath.row]
                let inStockProducts = inStockData[soldColorKey]?[soldStorageKey] ?? []
                let soldProducts = soldColorData[soldStorageKey] ?? []
                
                let stockCount = inStockProducts.count
                let soldCount = soldProducts.count
                
                cell.configure(with: soldStorageKey, stockCount: stockCount, soldCount: soldCount)
            }
        }
        
        return cell
    }

}




