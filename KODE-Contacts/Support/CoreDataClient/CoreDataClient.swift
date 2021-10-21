//
//  CoreDataClient.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import CoreData

class CoreDataClient {
    // MARK: - Properties
    private let persistentContainer = NSPersistentContainer(name: "KODE_Contacts")
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    init() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        context = persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    // MARK: - Public Methods
    // Contact
    func contactExists(_ contact: Contact) -> Bool {
        return objectWithSuchValueExists(columnName: #keyPath(PersistentContact.uuid),
                                         value: contact.uuid,
                                         objectType: PersistentContact.self)
    }
    
    func getAllContacts() -> [Contact] {
        guard let objects = getAllObjectsOfType(PersistentContact.self) else { return [] }
        return objects.map { $0.asContact }
    }
    
    func deleteAllContacts() throws {
        try deleteAllObjectsOfType(PersistentContact.self)
    }
    
    func createContact(_ contact: Contact) throws {
        let persistentContact = PersistentContact(context: context)
        persistentContact.setupWithContact(contact)
        try saveContext()
    }
    
    func updateContact(_ contact: Contact) throws {
        guard let results = getObjectsByValue(columnName: #keyPath(PersistentContact.uuid),
                                              value: contact.uuid,
                                              objectType: PersistentContact.self),
              let persistentContact = results.first else {
            throw CoreDataError.objectDoesNotExist
            
        }
        persistentContact.setupWithContact(contact)
        try saveContext()
    }
    
    func deleteContact(_ contact: Contact) throws {
        try deleteObjectsByValue(columnName: #keyPath(PersistentContact.uuid),
                                 value: contact.uuid,
                                 objectType: PersistentContact.self)
    }
    
    // MARK: - Private Methods
    private func objectWithSuchValueExists<Entity: NSManagedObject>(columnName: String,
                                                                    value: String,
                                                                    objectType: Entity.Type) -> Bool {
        
        let fetchRequest = createSafeComparisonFetchRequest(columnName: columnName, value: value, objectType: objectType)
        guard let objectCount = try? context.count(for: fetchRequest) else { return false }
        return objectCount > 0
    }
    
    private func getObjectsByValue<Entity: NSManagedObject>(columnName: String,
                                                            value: String,
                                                            objectType: Entity.Type) -> [Entity]? {
        
        let fetchRequest = createSafeComparisonFetchRequest(columnName: columnName, value: value, objectType: objectType)
        return try? context.fetch(fetchRequest)
    }
    
    private func getAllObjectsOfType<Entity: NSManagedObject>(_ type: Entity.Type) -> [Entity]? {
        let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest(entityName: String(describing: type))
        return try? context.fetch(fetchRequest)
    }
    
    private func deleteObjectsByValue<Entity: NSManagedObject>(columnName: String,
                                                               value: String,
                                                               objectType: Entity.Type) throws {
        
        guard let objects = getObjectsByValue(columnName: columnName, value: value, objectType: objectType) else {
            throw CoreDataError.objectDoesNotExist
        }
        for object in objects {
            context.delete(object)
        }
        try saveContext()
    }
    
    private func deleteAllObjectsOfType<Entity: NSManagedObject>(_ type: Entity.Type) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = type.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
    }
    
    private func createSafeComparisonFetchRequest<Entity: NSManagedObject>(columnName: String,
                                                                           value: String,
                                                                           objectType: Entity.Type) -> NSFetchRequest<Entity> {
        let safeColumnName = columnName.validatedForSQLQuery
        let safeValue = value.validatedForSQLQuery
        let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest(entityName: String(describing: objectType))
        // TODO: - Incorrect Key Path leads to fatal error. Handle it / change the function, keeping SQL Injection safety.
        fetchRequest.predicate = NSComparisonPredicate(leftExpression: NSExpression(forKeyPath: safeColumnName),
                                                       rightExpression: NSExpression(forConstantValue: safeValue),
                                                       modifier: .direct,
                                                       type: .equalTo,
                                                       options: .caseInsensitive)
        return fetchRequest
    }
    
    private func saveContext() throws {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error {
            context.rollback()
            throw error
        }
    }
    
}
