//
//  BaseModels.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 11.01.25.
//

import Foundation

struct Product: Codable {
    let id: String
    let name: String
    let description: String
    let category: String
    let color: String
    let stockDate: Date
    let salesDate: Date?
    let storage: String
}

struct ServiceOrder {
    var name: String
    var address: String
    var phone: String?
    var email: String?
    var scannedDocument: Data?
    var orderNumber: String?
    var customerNumber: String?
    var date: String?
}


//struct ServiceOrder {
//    var name: String
//    var address: String
//    var phone: String?
//    var email: String?
//    var scannedDocument: Data?
//}
