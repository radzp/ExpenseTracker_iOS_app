//
//  ChartValue.swift
//  ExpenseTracker
//
//  Created by Anna Paczesna on 14/06/2024.
//

import Foundation
import Combine

class ChartValue: ObservableObject {
    @Published var value: Double = 0.0
}
