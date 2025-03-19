//
//  ServiceOrderEntity+CoreDataProperties.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 03.03.25.
//
//

import Foundation
import CoreData


extension ServiceOrderEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServiceOrderEntity> {
        return NSFetchRequest<ServiceOrderEntity>(entityName: "ServiceOrderEntity")
    }

    @NSManaged public var address: String?
    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var scannedDocument: Data?
    @NSManaged public var orderNumber: String?
    @NSManaged public var customerNumber: String?
    @NSManaged public var date: String?

}

extension ServiceOrderEntity : Identifiable {

}
