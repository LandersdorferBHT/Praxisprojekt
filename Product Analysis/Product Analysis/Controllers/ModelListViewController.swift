//
//  ModelListViewController.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 06.03.25.
//

import UIKit

class ModelListViewController: UITableViewController {
    
    // List of products belonging to a selected category
    public var categorizedProducts: [Product] = []
    
    private var models: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ModelCell")
        
        // Extra unique model names based on the "name" attribute
        let modelSet = Set(categorizedProducts.map { $0.name })
        // Sort the models alphabetically
        models = Array(modelSet).sorted()
        
        self.title = "Modelle"
    }
    
    // MARK: - TableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModelCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = models[indexPath.row]
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedModel = models[indexPath.row]
        // Filter all products that match the selected model name
        let filteredProducts = categorizedProducts.filter { $0.name == selectedModel }
        
        // Perform segue and pass the filtered products to the next screen
        performSegue(withIdentifier: "showCategoryDetailController", sender: filteredProducts)
    }
    
    /// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategoryDetailController",
           let destinationVC = segue.destination as? CategoryDetailViewController,
           let filteredProducts = sender as? [Product] {
            // Passt the filtered products to the next view controller
            destinationVC.categorizedProducts = filteredProducts
            
            // Set navigation title of the destination VC to the model name
            destinationVC.title = filteredProducts.first?.name
        }
    }
}


