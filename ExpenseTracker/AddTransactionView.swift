//
//  AddTransactionView.swift
//  ExpenseTracker
//
//  Created by Anna Paczesna on 13/06/2024.
//

import Foundation
import SwiftUI

struct AddTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var merchant: String = ""
    @State private var amount: String = ""
    @State private var category: Category?
    @State private var date = Date()
    @State private var isExpense: Bool = true

    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>

    @State private var showAlert = false
    @State private var errorMessage = ""

    private var distinctCategories: [Category] {
        var set = Set<String>()
        return categories.filter { category in
            if let name = category.name, !set.contains(name) {
                set.insert(name)
                return true
            }
            return false
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TextField("Merchant", text: $merchant)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .frame(height: 30)

                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                

                Picker("Category", selection: $category) {
                    ForEach(distinctCategories, id: \.self) { category in
                        Text(category.name ?? "").tag(category as Category?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .frame(height: 40)

                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .datePickerStyle(GraphicalDatePickerStyle())

                Toggle("Expense", isOn: $isExpense)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                Button(action: saveTransaction) {
                    Text("Save")
                        .frame(maxWidth: .infinity, maxHeight: 30)
                }
                .buttonStyle(PrimaryButtonStyle())
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
            }
            .padding()
        }
        .navigationTitle("Add Transaction")
        .navigationBarItems(trailing: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            ensureDefaultCategoriesExist()
            if category == nil, let firstCategory = distinctCategories.first {
                category = firstCategory
            }
        }
    }

    private func saveTransaction() {
        do {
            let amountValue = try validateAmount(amount)

            guard let category = category else {
                errorMessage = "Please select a category"
                showAlert = true
                return
            }

            let newTransaction = Transaction(context: viewContext)
            newTransaction.id = UUID()
            newTransaction.date = date
            newTransaction.merchant = merchant
            newTransaction.amount = amountValue
            newTransaction.category = category
            newTransaction.isExpense = isExpense
            newTransaction.type = isExpense ? TransactionType.debit.rawValue : TransactionType.credit.rawValue

            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch let error as InvalidAmountError {
            errorMessage = error.localizedDescription
            showAlert = true
        } catch {
            errorMessage = "Unexpected error occurred"
            showAlert = true
        }
    }

    private func validateAmount(_ amount: String) throws -> Double {
        guard !amount.isEmpty else {
            throw InvalidAmountError.empty
        }
        
        guard let amountValue = Double(amount) else {
            throw InvalidAmountError.invalidFormat
        }

        return amountValue
    }

    private func ensureDefaultCategoriesExist() {
        let categoryNames = ["Grocery", "Transport", "Clothes", "Subscriptions"]
        for name in categoryNames {
            if !categories.contains(where: { $0.name == name }) {
                let newCategory = Category(context: viewContext)
                newCategory.name = name
                try? viewContext.save()
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue.cornerRadius(8))
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static let previewContext = PersistenceController.shared.container.viewContext
    
    static var previews: some View {
        NavigationView {
            AddTransactionView()
                .environment(\.managedObjectContext, previewContext)
        }
    }
}


//struct AddTransactionView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @Environment(\.presentationMode) var presentationMode
//
//    @State private var merchant: String = ""
//    @State private var amount: String = ""
//    @State private var category: Category?
//    @State private var date = Date()
//    @State private var isExpense: Bool = true
//
//    @FetchRequest(
//        entity: Category.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
//        animation: .default)
//    private var categories: FetchedResults<Category>
//
//    @State private var showAlert = false
//    @State private var errorMessage = ""
//
//    private var distinctCategories: [Category] {
//        var set = Set<String>()
//        return categories.filter { category in
//            if let name = category.name, !set.contains(name) {
//                set.insert(name)
//                return true
//            }
//            return false
//        }
//    }
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                TextField("Merchant", text: $merchant)
//                    .autocapitalization(.words)
//                    .disableAutocorrection(true)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//
//                TextField("Amount", text: $amount)
//                    .keyboardType(.decimalPad)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//
//                Picker("Category", selection: $category) {
//                    ForEach(distinctCategories, id: \.self) { category in
//                        Text(category.name ?? "").tag(category as Category?)
//                    }
//                }
//                .pickerStyle(MenuPickerStyle())
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(8)
//
//                DatePicker("Date", selection: $date, displayedComponents: .date)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//                    .datePickerStyle(GraphicalDatePickerStyle())
//
//                Toggle("Expense", isOn: $isExpense)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//
//                Button(action: saveTransaction) {
//                    Text("Save")
//                        .frame(maxWidth: .infinity, maxHeight: 30)
//                }
//                .buttonStyle(PrimaryButtonStyle())
////                .padding()
//                .background(Color.blue)
//                .cornerRadius(10)
//                .foregroundColor(.white)
//            }
//            .padding()
//        }
//        .navigationTitle("Add Transaction")
//        .navigationBarItems(trailing: Button("Cancel") {
//            presentationMode.wrappedValue.dismiss()
//        })
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
//        }
//        .onAppear {
//            if category == nil, let firstCategory = distinctCategories.first {
//                category = firstCategory
//            }
//        }
//    }
//
//    private func saveTransaction() {
//        do {
//            let amountValue = try validateAmount(amount)
//
//            guard let category = category else {
//                errorMessage = "Please select a category"
//                showAlert = true
//                return
//            }
//
//            let newTransaction = Transaction(context: viewContext)
//            newTransaction.id = UUID()
//            newTransaction.date = date
//            newTransaction.merchant = merchant
//            newTransaction.amount = amountValue
//            newTransaction.category = category
//            newTransaction.isExpense = isExpense
//            newTransaction.type = isExpense ? TransactionType.debit.rawValue : TransactionType.credit.rawValue
//
//            try viewContext.save()
//            presentationMode.wrappedValue.dismiss()
//        } catch let error as InvalidAmountError {
//            errorMessage = error.localizedDescription
//            showAlert = true
//        } catch {
//            errorMessage = "Unexpected error occurred"
//            showAlert = true
//        }
//    }
//
//    private func validateAmount(_ amount: String) throws -> Double {
//        guard !amount.isEmpty else {
//            throw InvalidAmountError.empty
//        }
//        
//        guard let amountValue = Double(amount) else {
//            throw InvalidAmountError.invalidFormat
//        }
//
//        return amountValue
//    }
//}
//
//struct PrimaryButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding()
//            .background(Color.blue.cornerRadius(8))
//            .foregroundColor(.white)
//            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
//    }
//}
//
//struct AddTransactionView_Previews: PreviewProvider {
//    static let previewContext = PersistenceController.shared.container.viewContext
//    
//    static var previews: some View {
//        NavigationView {
//            AddTransactionView()
//                .environment(\.managedObjectContext, previewContext)
//        }
//    }
//}
