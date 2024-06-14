//
//  PersistenceController.swift
//  ExpenseTracker
//
//  Created by Anna Paczesna on 13/06/2024.
//

import Foundation

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ExpenseTracker")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { [weak self] (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self?.loadTestData()
        }
    }

    func loadTestData() {
//        let context = container.viewContext
//        let category1 = Category(context: context)
//        category1.id = UUID()
//        category1.name = "Groceries"
//        category1.icon = "shopping_cart"
//
//        let category2 = Category(context: context)
//        category2.id = UUID()
//        category2.name = "Transport"
//        category2.icon = "car_alt"
//
//        let transaction1 = Transaction(context: context)
//        transaction1.id = UUID()
//        transaction1.date = Date()
//        transaction1.merchant = "Supermarket"
//        transaction1.amount = 50.00
//        transaction1.category = category1
//        transaction1.isExpense = true
//        transaction1.type = TransactionType.debit.rawValue
//
//        let transaction2 = Transaction(context: context)
//        transaction2.id = UUID()
//        transaction2.date = Date()
//        transaction2.merchant = "Gas Station"
//        transaction2.amount = 30.00
//        transaction2.category = category2
//        transaction2.isExpense = true
//        transaction2.type = TransactionType.debit.rawValue
//
//        do {
//            try context.save()
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
    }
}







//
//
//import CoreData
//
//struct PersistenceController {
//    static let shared = PersistenceController()
//
//    let container: NSPersistentContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "ExpenseTracker")
//        if inMemory {
//            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//            self.loadTestData()
//        }
//    }
//
//    func loadTestData() {
//        let context = container.viewContext
//        let category1 = Category(context: context)
//        category1.id = UUID()
//        category1.name = "Groceries"
//        category1.icon = "shopping_cart"
//
//        let category2 = Category(context: context)
//        category2.id = UUID()
//        category2.name = "Transport"
//        category2.icon = "car_alt"
//
//        let transaction1 = Transaction(context: context)
//        transaction1.id = UUID()
//        transaction1.date = Date()
//        transaction1.merchant = "Supermarket"
//        transaction1.amount = 50.00
//        transaction1.category = category1
//        transaction1.isExpense = true
//        transaction1.type = TransactionType.debit.rawValue
//
//        let transaction2 = Transaction(context: context)
//        transaction2.id = UUID()
//        transaction2.date = Date()
//        transaction2.merchant = "Gas Station"
//        transaction2.amount = 30.00
//        transaction2.category = category2
//        transaction2.isExpense = true
//        transaction2.type = TransactionType.debit.rawValue
//
//        do {
//            try context.save()
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
//}
//
//
//
////import CoreData
////
////struct PersistenceController {
////    static let shared = PersistenceController()
////
////    let container: NSPersistentContainer
////
////    init(inMemory: Bool = false) {
////        container = NSPersistentContainer(name: "ExpenseTracker")
////        if inMemory {
////            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
////        }
////        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
////            if let error = error as NSError? {
////                fatalError("Unresolved error \(error), \(error.userInfo)")
////            }
////        })
////    }
////}
