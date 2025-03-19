//
//  CoreDataManager.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 27.02.25.
//

import CoreData
import UIKit

class CoreDataManager {
    
    // Singleton instance to ensure a single shared instance of 'CoreData' is used
    static let shared = CoreDataManager()  // Singleton-Instanz
    
    private init() { }
    
    // MARK: - CoreData Stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Product_Analysis") // Dein CoreData Model Name
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Context for performing core data operations
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - CoreData Methods
    
    // Fetches all 'ServiceOrder' objects from core data and maps them to model objects
    func fetchAllServiceOrders() -> [ServiceOrder]? {
        let fetchRequest: NSFetchRequest<ServiceOrderEntity> = ServiceOrderEntity.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.map { ServiceOrder(name: $0.name ?? "", address: $0.address ?? "", phone: $0.phone, email: $0.email, scannedDocument: $0.scannedDocument, orderNumber: $0.orderNumber, customerNumber: $0.customerNumber, date: $0.date) }
        } catch {
            print("Fehler beim Abrufen der ServiceOrders: \(error)")
            return nil
        }
    }
    
    // Saves a new 'ServiceOrder' object into core data
    func saveServiceOrder(serviceOrder: ServiceOrder) {
        let serviceOrderEntity = ServiceOrderEntity(context: context)
        serviceOrderEntity.name = serviceOrder.name
        serviceOrderEntity.address = serviceOrder.address
        serviceOrderEntity.phone = serviceOrder.phone
        serviceOrderEntity.email = serviceOrder.email
        serviceOrderEntity.scannedDocument = serviceOrder.scannedDocument
        serviceOrderEntity.orderNumber = serviceOrder.orderNumber
        serviceOrderEntity.customerNumber = serviceOrder.customerNumber
        serviceOrderEntity.date = serviceOrder.date
        
        saveContext()
    }

    // Finds a 'ServiceOrderEntity' in core data that matches a given 'ServiceOrder' model
    func findServiceOrderEntity(by serviceOrder: ServiceOrder) -> ServiceOrderEntity? {
            let fetchRequest: NSFetchRequest<ServiceOrderEntity> = ServiceOrderEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", serviceOrder.name)
            
            do {
                let result = try context.fetch(fetchRequest)
                return result.first
            } catch {
                print("Fehler beim Finden der ServiceOrderEntity: \(error)")
                return nil
            }
        }

    // Deletes a 'ServiceOrderEntity' from core data
    func deleteServiceOrder(serviceOrder: ServiceOrderEntity) {
        context.delete(serviceOrder)
        saveContext()
    }
    
    // Saves changes in the core data context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Fehler beim Speichern des Kontexts: \(error)")
            }
        }
    }
    
    // Returns the core data context
    func getContext() -> NSManagedObjectContext {
        return context
    }
}







