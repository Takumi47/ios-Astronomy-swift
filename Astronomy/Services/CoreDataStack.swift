//
//  CoreDataStack.swift
//  Astronomy
//
//  Created by xander on 2021/4/11.
//

import CoreData

class CoreDataStack {
    
    // MARK: - Properties
    
    private let modelName: String
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let err = error as NSError? {
                fatalError("Unresolved error \(err), \(err.userInfo)")
            }
        }
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        self.storeContainer.viewContext
    }()
    
    static var apod: CoreDataStack = {
        CoreDataStack(modelName: "Apod")
    }()
    
    // MARK: - Lifecycle
    
    init(modelName: String) {
        self.modelName = modelName
    }
}

// MARK: - Methods

extension CoreDataStack {
    
    func saveContext() {
        guard mainContext.hasChanges else { return }
        do {
            try mainContext.save()
        } catch let err as NSError {
            fatalError("Unresolved error \(err), \(err.userInfo)")
        }
    }
}
