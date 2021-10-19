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
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        context = persistentContainer.viewContext
    }
    
    func getAllContacts() -> [Contact]? {
        guard let objects = fetchAllObjects(objectType: PersistentContact.self) else { return nil }
        return objects.map { Contact(from: $0) }
    }
    
    func createContact(_ contact: Contact) -> Result<PersistentContact, Error> {
        
        let persistentContact = PersistentContact(context: context)
        persistentContact.phoneNumber = contact.phoneNumber
        
        if objectExists(object: persistentContact) {
            return .failure(ValidationError.repeatedPhoneNumber)
        }
        
        persistentContact.avatarImagePath = contact.avatarImagePath
        persistentContact.lastName = contact.lastName
        persistentContact.notes = contact.notes
        persistentContact.ringtone = contact.ringtone.rawValue
        persistentContact.name = contact.name
        
        if saveContext() {
            return .success(persistentContact)
        } else {
            return .failure(ValidationError.repeatedPhoneNumber)
        }
        
    }
    
    func objectExists<Entity: EntityWithID>(object: Entity) -> Bool {
        let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest(entityName: String(describing: Entity.self))
        fetchRequest.predicate = NSPredicate(format: "\(object.idName) == %@", object.id)

        let objectCount = try? context.count(for: fetchRequest)
        return objectCount ?? 0 > 0
    }
    
    private func fetchAllObjects<Entity: NSManagedObject>(objectType: Entity.Type) -> [Entity]? {
        let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest(entityName: String(describing: objectType))
        let objects = try? context.fetch(fetchRequest)
        return objects
    }
    
    private func deleteObject<Entity: NSManagedObject>(object: Entity) -> Bool {
        context.delete(object)
        return saveContext()
    }
    
    private func saveContext() -> Bool {
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                context.rollback()
                return false
            }
        }
        return true
    }
    
}
