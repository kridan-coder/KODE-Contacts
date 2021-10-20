//
//  CoreDataClient.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import CoreData

class CoreDataClient {
    var context: NSManagedObjectContext
    
    var persistentContainer = NSPersistentContainer(name: "KODE_Contacts")
    
    init() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        context = persistentContainer.viewContext
    }
    
//    func getContactByID(uuid: String) -> Contact? {
//        return getObjectByID()
//    }
    
    func getAllContacts() -> [Contact] {
        guard let objects = getAllObjectsOfType(PersistentContact.self) else { return [] }
        return objects.map { Contact(from: $0) }
    }
    
    func createContact(_ contact: Contact) -> Result<Void, Error> {
        let persistentContact = PersistentContact(context: context)
        persistentContact.phoneNumber = contact.phoneNumber
        persistentContact.avatarImagePath = contact.avatarImagePath
        persistentContact.lastName = contact.lastName
        persistentContact.notes = contact.notes
        persistentContact.ringtone = contact.ringtone.rawValue
        persistentContact.name = contact.name
        persistentContact.uuid = contact.uuid
        return saveContext()
    }
    
    func objectWithSuchIDExists<Entity: EntityWithID>(_ object: Entity) -> Bool {
        let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest(entityName: String(describing: Entity.self))
        fetchRequest.predicate = NSPredicate(format: "\(object.idName) == %@", object.id)
        guard let objectCount = try? context.count(for: fetchRequest) else { return false }
        return objectCount > 0
    }
    
    private func getObjectsByValue<Entity: NSManagedObject>(columnName: String,
                                                            value: String,
                                                            objectType: Entity.Type) -> [Entity]? {
        let safeColumnName = columnName.validatedForSQLQuery
        let safeValue = value.validatedForSQLQuery
        
        let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest(entityName: String(describing: objectType))
        fetchRequest.predicate = NSPredicate(format: "\(safeColumnName) == %@", safeValue)
        
        return try? context.fetch(fetchRequest)
    }
    
    private func getAllObjectsOfType<Entity: NSManagedObject>(_ type: Entity.Type) -> [Entity]? {
        let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest(entityName: String(describing: type))
        return try? context.fetch(fetchRequest)
    }
    
    private func deleteObjectsByValue<Entity: NSManagedObject>(columnName: String,
                                                               value: String,
                                                               objectType: Entity.Type) -> Result<Void, Error> {
        guard let objects = getObjectsByValue(columnName: columnName, value: value, objectType: objectType) else {
            return .failure(ValidationError.unhandled)
        }
        
        for object in objects {
            context.delete(object)
        }
        
        return saveContext()
    }
    
//    private func deleteObjectByID<Entity: EntityWithID>(_ object: Entity) -> Result<Void, Error> {
//        guard let object = getObjectByID(object) else { return .failure(ValidationError.unhandled)}
//        context.delete(object)
//        return saveContext()
//    }

    
//    private func getObjectByID<Entity: EntityWithID>(_ object: Entity) -> NSManagedObject? {
//        let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest(entityName: String(describing: Entity.self))
//        fetchRequest.predicate = NSPredicate(format: "\(object.idName) == %@", object.id)
//        guard let fetchResults = try? context.fetch(fetchRequest) else { return nil }
//        return fetchResults.first
//    }
    
    private func deleteAllObjectsOfType<Entity: NSManagedObject>(_ type: Entity.Type) -> Result<Void, Error> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = type.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            return .success(())
        } catch let error {
            return .failure(error)
        }
    }
    
    private func saveContext() -> Result<Void, Error> {
        guard context.hasChanges else { return .success(()) }
        do {
            try context.save()
            return .success(())
        } catch let error {
            context.rollback()
            return .failure(error)
        }
    }
    
}
