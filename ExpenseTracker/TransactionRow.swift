//
//  TransactionRow.swift
//  ExpenseTracker
//
//  Created by Anna Paczesna on 13/06/2024.
//

import Foundation
import SwiftUI
import SwiftUIFontIcon


struct TransactionRow: View {
    var transaction: Transaction

    var body: some View {
        HStack(spacing: 20) {
            // MARK: Transaction Category Icon
            if let category = transaction.category,
               let icon = FontAwesomeCode(rawValue: category.icon ?? "") {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(MyColors.icon.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .overlay {
                        FontIcon.text(.awesome5Solid(code: icon), fontsize: 24, color: MyColors.icon)
                    }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                // MARK: Transaction Merchant
                Text(transaction.merchant ?? "")
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                
                // MARK: Transaction Category
                Text(transaction.category?.name ?? "")
                    .font(.footnote)
                    .opacity(0.7)
                    .lineLimit(1)
                
                // MARK: Transaction Date
                Text(transaction.date ?? Date(), format: .dateTime.year().month().day())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // MARK: Transaction Amount
            Text(transaction.signedAmount, format: .currency(code: "USD"))
                .bold()
                .foregroundColor(transaction.type == TransactionType.credit.rawValue ? MyColors.text : .primary)
        }
        .padding([.top, .bottom], 8)
    }
}

//#Preview {
//    TransactionRow(transaction: transactionPreviewData)
//}
