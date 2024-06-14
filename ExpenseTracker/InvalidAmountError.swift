//
//  InvalidAmountError.swift
//  ExpenseTracker
//
//  Created by Anna Paczesna on 13/06/2024.
//

import Foundation


enum InvalidAmountError: LocalizedError {
    case empty
    case invalidFormat

    var errorDescription: String? {
        switch self {
        case .empty:
            return "Amount cannot be empty"
        case .invalidFormat:
            return "Amount is in an invalid format"
        }
    }
}
