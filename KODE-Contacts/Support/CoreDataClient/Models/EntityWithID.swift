//
//  ObjectWithID.swift
//  KODE-Contacts
//
//  Created by Developer on 19.10.2021.
//

import CoreData

protocol EntityWithID: NSManagedObject {
    var id: String { get }
    var idName: String { get }
}

extension PersistentContact: EntityWithID {
    public var id: String {
        self.uuid ?? ""
    }
    internal var idName: String {
        #keyPath(PersistentContact.uuid)
    }
}
