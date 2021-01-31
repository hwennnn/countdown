//
//  CoreDataStack.swift
//  countdown
//
//  Created by shadow on 30/1/21.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    var managedObjectContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    var workingContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.managedObjectContext
        return context
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Events")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                RaiseError.raise()
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        self.managedObjectContext.performAndWait {
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                    appPrint("Main context saved")
                } catch {
                    appPrint(error)
                    RaiseError.raise()
                }
            }
        }
    }

    func saveWorkingContext(context: NSManagedObjectContext) {
        do {
            try context.save()
            appPrint("Working context saved")
            saveContext()
        } catch (let error) {
            appPrint(error)
            RaiseError.raise()
        }
    }
}
