//
//  TransactionList.swift
//  ExpenseTracker
//
//  Created by Anna Paczesna on 13/06/2024.
//

import Foundation
import SwiftUI



struct TransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Transaction.entity(),
         sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)],
           animation: .default)
    private var transactions: FetchedResults<Transaction>

    var body: some View {
        VStack {
            List {
            // MARK: Transaction Group
                ForEach(Array(transactionListVM.groupTransactionsByMonth(transactions: transactions.map { $0 })), id: \.key) { month, transactions in
                    Section {
                        // MARK: Transaction List
                        ForEach(transactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                        .onDelete(perform: deleteTransaction)
                    } header : {
                        //MARK: Transaction Month
                        Text(month)
                    }
                    .listSectionSeparator(.hidden)
                }
            }
     .listStyle(.plain)
            
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func deleteTransaction(at offsets: IndexSet) {
        offsets.forEach { index in
            let transaction = transactions[index]
            transactionListVM.deleteTransaction(transaction)
        }
    }
}

struct TransactionList_Previews: PreviewProvider {
    static let previewContext = PersistenceController.shared.container.viewContext
    
    static var previews: some View {
        TransactionList()
            .environment(\.managedObjectContext, previewContext)
            .environmentObject(TransactionListViewModel(preview: true))
    }
}


//struct TransactionList: View {
//    @EnvironmentObject var transactionListVM: TransactionListViewModel
//    @Environment(\.managedObjectContext) private var viewContext
//    
//    @FetchRequest(
//        entity: Transaction.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)],
//        animation: .default)
//    private var transactions: FetchedResults<Transaction>
//
//    var body: some View {
//        VStack {
//            List {
//                // MARK: Transaction Group
//                ForEach(Array(transactionListVM.groupTransactionsByMonth(transactions: transactions.map { $0 })), id: \.key) { month, transactions in
//                    Section {
//                        // MARK: Transaction List
//                        ForEach(transactions) { transaction in
//                            TransactionRow(transaction: transaction)
//                        }
//                        
//                    } header : {
//                        //MARK: Transaction Month
//                        Text(month)
//                    }
//                    .listSectionSeparator(.hidden)
//                }
//            }
//            .listStyle(.plain)
//            
//        }
//        .navigationTitle("Transactions")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//struct TransactionList_Previews: PreviewProvider {
//    static let previewContext = PersistenceController.shared.container.viewContext
//    
//    static var previews: some View {
//        TransactionList()
//            .environment(\.managedObjectContext, previewContext)
//            .environmentObject(TransactionListViewModel(preview: true))
//    }
//}
