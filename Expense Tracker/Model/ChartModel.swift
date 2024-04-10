//
//  ChartModel.swift
//  Expense Tracker
//
//  Created by Frank Chen on 2024-04-02.
//

import Foundation

struct ChartGroup: Identifiable {
    let id = UUID()
    var date: Date
    var categories: [ChartCategory]
    var totalIncome: Double
    var totalExpense: Double
}

struct ChartCategory: Identifiable {
    let id = UUID()
    var totalValue: Double
    var category: Category
}
