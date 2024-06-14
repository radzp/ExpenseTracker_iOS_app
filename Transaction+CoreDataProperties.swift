//
//  Transaction+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Anna Paczesna on 13/06/2024.
//
//

import Foundation
import CoreData

extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var merchant: String?
    @NSManaged public var amount: Double
    @NSManaged public var type: String?
    @NSManaged public var isExpense: Bool
    @NSManaged public var category: Category?

    var signedAmount: Double {
        return type == TransactionType.credit.rawValue ? amount : -amount
    }
    
    var month: String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

extension Transaction: Identifiable { }
