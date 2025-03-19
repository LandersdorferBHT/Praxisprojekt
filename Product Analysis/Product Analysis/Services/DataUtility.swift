//
//  DataUtility.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 11.01.25.
//

import Foundation

class DataImporter {
    
    // Loads product data from a JSON file in the app bundle
    func loadProducts(from fileName: String) -> [Product] {
        
        // Locate the JSON file in the app bundle and load its contents
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        
        do {
            // Decode the JSON data into an array of 'Product' objects
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Product].self, from: data)
            
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
}
