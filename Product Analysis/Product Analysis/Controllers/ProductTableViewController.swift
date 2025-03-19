//
//  ProductTableViewController.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 16.02.25.
//

import UIKit

class ProductTableViewController: UITableViewController {
    
    // List of all products
    public var products: [Product] = []
    
    // List of products filtered by selected category
    private var selectedCategory: [Product] = []
    
    // Inventory manager instance to handle product data
    private var inventoryManager: InventoryManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ProductSelectionCell.self, forCellReuseIdentifier: "ProductSelectionCell")
        
        // Initialize inventory manager with provided products
        inventoryManager = InventoryManager(products: products)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        
        navigationItem.title = "Geräteübersicht"
    }
    
    /// MARK: - TableView Data Source Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventoryManager?.getCategories().count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSelectionCell", for: indexPath) as? ProductSelectionCell else {
            return UITableViewCell()
        }
        
        if let categories = inventoryManager?.getCategories() {
            
            // Sort categories based on the number of sold products (descending)
            let sortedCategories = categories.sorted { category1, category2 in
                let count1 = products.filter { $0.category == category1 && $0.salesDate != nil }.count
                let count2 = products.filter { $0.category == category2 && $0.salesDate != nil }.count
                return count1 > count2
            }
            
            let category = sortedCategories[indexPath.row]
            let stockCount = products.filter { $0.category == category && $0.salesDate == nil }.count
            
            cell.configure(with: category, stockCount: stockCount)
        }
        
        return cell
    }


    
    
    /// MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showModelController", sender: self)
    }
    
    /// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showModelController",
           let destVC = segue.destination as? ModelListViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            
            // Get the sorted list of categories
            let sortedCategories = getSortedCategories()
            let selectedCategory = sortedCategories[indexPath.row]

            // Retrieve all products belonging to the selected category
            let categoryProducts = products.filter { $0.category == selectedCategory }
            
            // Pass the filtered products to the next view controller
            destVC.categorizedProducts = categoryProducts
        }
    }

    // Returns a sorted list of product categories bases on sales count (descending)
    private func getSortedCategories() -> [String] {
        guard let categories = inventoryManager?.getCategories() else {
            return []
        }
        
        return categories.sorted { category1, category2 in
            let count1 = products.filter { $0.category == category1 && $0.salesDate != nil }.count
            let count2 = products.filter { $0.category == category2 && $0.salesDate != nil }.count
            return count1 > count2
        }
    }

}


