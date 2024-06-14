//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Anna Paczesna on 13/06/2024.
//



import SwiftUI
import CoreData
import SwiftUICharts


struct ContentView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Transaction.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)],
        animation: .default)
    private var transactions: FetchedResults<Transaction>

    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>

    let backgroundColor = MyColors.background
    let iconColor = MyColors.icon
    let textColor = MyColors.text
    let systemBackgroundColor = MyColors.systemBackground

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24){
                
                    // MARK: Title
                    Text("Overview")
                        .font(.title2)
                        .bold()
                    
                    // MARK: Chart
                    let data = transactionListVM.accumulateTransactions(transactions: transactions.map { $0 })
                    
//                    // Convert data to a string format for display
//                                        let dataString = data.map { "\($0.0): \($0.1)" }.joined(separator: "\n")
//                                        
//                                        // Display the data string
//                                        Text(dataString)
//                                            .padding()
//                                            .background(Color.gray.opacity(0.2))
//                                            .cornerRadius(8)

                    if !data.isEmpty {
                        let totalExpenses = data.last?.1 ?? 0.0
                        
                        CardView {
                            VStack(alignment: .leading) {
                                ChartLabel(totalExpenses.formatted(.currency(code: "USD")), type: .title, format: "$%.02f")
                                LineChart()
                            }
                            .background(MyColors.systemBackground)
                        }
                        .data(data.map { $0.1 })
                        .chartStyle(ChartStyle(
                            backgroundColor: MyColors.systemBackground,
                            foregroundColor: ColorGradient(MyColors.icon.opacity(0.4), MyColors.icon))
                        )
                        .frame(height: 300)
                    }
                    
                    // MARK: Transaction List
                    RecentTransactionList()
                    
                    // MARK: Add Transaction Button
                    NavigationLink(destination: AddTransactionView()) {
                        Text("Add New Transaction")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(MyColors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: Notification Icon
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(MyColors.icon, .primary)
                }
            }
            .navigationViewStyle(.stack)
            .accentColor(.primary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let previewContext = PersistenceController.shared.container.viewContext
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, previewContext)
            .environmentObject(TransactionListViewModel(preview: true))
    }
}








//
//struct ContentView: View {
//    @EnvironmentObject var transactionListVM: TransactionListViewModel
//    @Environment(\.managedObjectContext) private var viewContext
//    
//    @FetchRequest(
//        entity: Transaction.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)],
//        animation: .default)
//    private var transactions: FetchedResults<Transaction>
//
//    @FetchRequest(
//        entity: Category.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
//        animation: .default)
//    private var categories: FetchedResults<Category>
//
//    let backgroundColor = MyColors.background
//    let iconColor = MyColors.icon
//    let textColor = MyColors.text
//    let systemBackgroundColor = MyColors.systemBackground
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 24){
//                    // MARK: Title
//                    Text("Overview")
//                        .font(.title2)
//                        .bold()
//                    
//                    // MARK: Chart
//                    let data = transactionListVM.accumulateTransactions(transactions: transactions.map { $0 })
//
//                    if !data.isEmpty {
//                        let totalExpenses = data.last?.1 ?? 0
//                        
//                        CardView {
//                            VStack(alignment: .leading){
//                                ChartLabel(totalExpenses.formatted(.currency(code: "USD")), type: .title, format: "$%.02f")
//                            
//                                LineChart()
//                            }
//                            .background(MyColors.systemBackground)
//                        }
//                        .data(data)
//                        .chartStyle(ChartStyle(backgroundColor: MyColors.systemBackground, foregroundColor: ColorGradient(MyColors.icon.opacity(0.4), MyColors.icon)))
//                        .frame(height: 300)
//                    }
//                    
//                    // MARK: Transaction List
//                    RecentTransactionList()
//                    
//                    // MARK: Add Transaction Button
//                    NavigationLink(destination: AddTransactionView()) {
//                        Text("Add New Transaction")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .center)
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//            }
//            .background(MyColors.background)
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                // MARK: Notification Icon
//                ToolbarItem {
//                    Image(systemName: "bell.badge")
//                        .symbolRenderingMode(.palette)
//                        .foregroundStyle(MyColors.icon, .primary)
//                }
//            }
//            .navigationViewStyle(.stack)
//            .accentColor(.primary)
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static let previewContext = PersistenceController.shared.container.viewContext
//    
//    static var previews: some View {
//        ContentView()
//            .environment(\.managedObjectContext, previewContext)
//            .environmentObject(TransactionListViewModel(preview: true))
//    }
//}
//
