//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by Anna Paczesna on 13/06/2024.
//

import Foundation
import Collections
import Combine
import CoreData

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]


final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var context: NSManagedObjectContext
    
    init(preview: Bool = false) {
        context = PersistenceController.shared.container.viewContext
        if preview {
            loadTestData()
        } else {
            getTransactions()
        }
    }
    
    func getTransactions() {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)]
        
        do {
            transactions = try context.fetch(request)
        } catch {
            print("Error fetching transactions: \(error)")
        }
    }
    
    func groupTransactionsByMonth(transactions: [Transaction]) -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        let groupedTransactions = TransactionGroup(grouping: transactions) { $0.month ?? "" }
        return groupedTransactions
    }
    
    func accumulateTransactions(transactions: [Transaction]) -> TransactionPrefixSum {
        guard !transactions.isEmpty else { return [] }

        // Ustal daty pierwszej i ostatniej transakcji
        guard let firstTransactionDate = transactions.first?.date, let lastTransactionDate = transactions.last?.date else {
            return []
        }

        // Przygotuj kalendarz do obliczeń
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        var currentDate = calendar.startOfDay(for: firstTransactionDate)
        let endDate = calendar.startOfDay(for: lastTransactionDate)
        
        while currentDate <= endDate {
            let dailyExpenses = transactions.filter { calendar.isDate($0.date ?? Date(), inSameDayAs: currentDate) }
            
            let dailyTotal = dailyExpenses.reduce(0) { (result, transaction) in
                return result + (transaction.type == TransactionType.debit.rawValue ? -transaction.amount : transaction.amount)
            }
            
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((dateFormatter.string(from: currentDate), sum))
            
            // Przesuń się o jeden dzień do przodu
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return cumulativeSum
    }

    
    private func loadTestData() {
        // Load test data for preview
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        context.delete(transaction)
        do {
            try context.save()
            getTransactions() // Refresh the list of transactions
        } catch {
            print("Error deleting transaction: \(error)")
            }
    }
    
    // Debugging method to print the result of accumulateTransactions
    func debugAccumulateTransactions() {
        let result = accumulateTransactions(transactions: transactions)
        for (date, sum) in result {
            print("\(date): \(sum)")
        }
    }
}


//final class TransactionListViewModel: ObservableObject {
//    @Published var transactions: [Transaction] = []
//
//    private var cancellables = Set<AnyCancellable>()
//    private var context: NSManagedObjectContext
//
//    init(preview: Bool = false) {
//        context = PersistenceController.shared.container.viewContext
//        if preview {
//            loadTestData()
//        } else {
//            getTransactions()
//        }
//    }
//
//    func getTransactions() {
//        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)]
//
//        do {
//            transactions = try context.fetch(request)
//        } catch {
//            print("Error fetching transactions: \(error)")
//        }
//    }
//
//    func groupTransactionsByMonth(transactions: [Transaction]) -> TransactionGroup {
//        guard !transactions.isEmpty else { return [:] }
//        let groupedTransactions = TransactionGroup(grouping: transactions) { $0.month ?? "" }
//        return groupedTransactions
//    }
//
//    func accumulateTransactions(transactions: [Transaction]) -> TransactionPrefixSum {
//        guard !transactions.isEmpty else { return [] }
//
//        guard let firstTransactionDate = transactions.first?.date, let lastTransactionDate = transactions.last?.date else {
//            return []
//        }
//
//        var sum: Double = .zero
//        var cumulativeSum = TransactionPrefixSum()
//
//        for date in stride(from: firstTransactionDate, to: lastTransactionDate, by: 60 * 60 * 24) {
//            let dailyExpenses = transactions.filter { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }
//
//            let dailyTotal = dailyExpenses.reduce(0) { (result, transaction) in
//                return result + (transaction.type == TransactionType.debit.rawValue ? -transaction.amount : transaction.amount)
//            }
//
//            sum += dailyTotal
//            sum = sum.roundedTo2Digits()
//            cumulativeSum.append((date.formatted(), sum))
//        }
//        return cumulativeSum
//    }
//
//    private func loadTestData() {
//        // Load test data for preview
//    }
//
//    // Debugging method to print the result of accumulateTransactions
//    func debugAccumulateTransactions() {
//        let result = accumulateTransactions(transactions: transactions)
//        for (date, sum) in result {
//            print("\(date): \(sum)")
//        }
//    }
//}
