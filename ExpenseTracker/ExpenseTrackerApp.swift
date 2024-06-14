//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Anna Paczesna on 13/06/2024.
//


import SwiftUI

//@main
//struct ExpenseTrackerApp: App {
//
//    @StateObject var transactionListVM = TransactionListViewModel()
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(transactionListVM)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
//}



@main
struct ExpenseTrackerApp: App {
    @StateObject private var chartValue = ChartValue()
    @StateObject private var transactionListVM = TransactionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(chartValue)
                .environmentObject(transactionListVM)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
