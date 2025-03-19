//
//  ProductViewController.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 10.02.25.
//



import UIKit
import SwiftUI

class OverviewTableViewController: UITableViewController {
    
    // Data for the best selling products
    var topSales: [(name: String, count: Int)] = []
    
    // List of all products
    var products: [Product] = []
    
    // Inventory statistics
    var stockCount = 0
    var oldStockCount = 0
    var categoryCount = 0
    var mostStoredCategory = ""
    
    // Inventory manager instance
    var inventoryManager: InventoryManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load product data using the 'DataImproter'
        let importer = DataImporter()
        products = importer.loadProducts(from: "products")

        // Initialze the inventory manager with loaded products
        inventoryManager = InventoryManager(products: products)
        
        // Retrieve key inventory statistics
        topSales = (inventoryManager?.getTopSales()) ?? []
        stockCount = inventoryManager?.getStockCount() ?? 0
        oldStockCount = inventoryManager?.getOldStockCount() ?? 0
        categoryCount = inventoryManager?.getCategoryCount() ?? 0
        mostStoredCategory = inventoryManager?.getMostStoredCategory() ?? "No Categories"
        
        tableView.reloadData()

    }
    
    /// MARK: - TableView Data Source Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            switch indexPath.row {
                
            case 0:
                // First row - Displays an overview of inventory statistics
                let cell = OverviewAnalysisCell(style: .default, reuseIdentifier: nil)
                cell.configure(title: "📊 Analyse", details: "📦 \(stockCount) Geräte im Lager\n⏳ \(oldStockCount) Gerät älter als 30 Tage")
                return cell
                
            case 1:
                // Second row - Displays an overview or product categories
                let cell = OverviewListCell(style: .default, reuseIdentifier: nil)
                cell.configure(title: "📦 Geräteübersicht", details: "🏷 \(categoryCount) Kategorien\n🔥 Meistgelagerte: \(mostStoredCategory)")
                return cell
                
            default:
                // Should never happend, as only two rows are expected
                fatalError("Unexpected row index")
            }
        }
    
    /// MARK: - TabieView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "showAnalyseController", sender: self)
 
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "showProductController", sender: self)
        }
    }
    
    /// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAnalyseController" {
            
            // Pass product data to analysis screen
            if let destVC = segue.destination as? AnalysisTableViewController {
                destVC.products = self.products
            }
            
        } else if segue.identifier == "showProductController" {
            
            // Pass product data to the product overview screen
            if let destVC = segue.destination as? ProductTableViewController {
                destVC.products = self.products
            }
            
        }
    }
    
}




