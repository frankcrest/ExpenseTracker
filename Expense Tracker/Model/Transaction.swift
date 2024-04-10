//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Frank Chen on 2024-04-01.
//

import SwiftUI
import SwiftData

@Model
class Transaction {
    var title: String
    var remarks: String
    var category: String
    var tintColor: String
    var amount: Double
    var dateAdded: Date
    
    init(title: String, remarks: String, category: Category, tintColor: TintColor, amount: Double, dateAdded: Date) {
        self.title = title
        self.remarks = remarks
        self.category = category.rawValue
        self.tintColor = tintColor.color
        self.amount = amount
        self.dateAdded = dateAdded
    }
    
    // Extracting Color Value from tintColor Strin
    @Transient
    var color: Color {
        return tints.first(where:  {$0.color == tintColor})?.value ?? appTint
    }
    
    @Transient
    var tint: TintColor? {
        return tints.first(where:  {$0.color == tintColor})
    }
    
    @Transient
    var rawCategory: Category? {
        return Category.allCases.first(where: { category == $0.rawValue })
    }
}

// Sample Transactions for UIBuilding
let sampleTransactions: [Transaction] = [
    Transaction(title: "Grocery Shopping", remarks: "Weekly grocery shopping", category: .income, tintColor: tints.randomElement()!, amount: 85.50, dateAdded: Date().randomDate),
    Transaction(title: "Dinner at Restaurant", remarks: "Celebrating anniversary", category: .expense, tintColor: tints.randomElement()!, amount: 120.00, dateAdded: Date().randomDate),
    Transaction(title: "Uber Ride", remarks: "To office", category: .income, tintColor: tints.randomElement()!, amount: 15.75, dateAdded: Date().randomDate),
    Transaction(title: "Movie Tickets", remarks: "Avengers: Endgame", category: .expense, tintColor: tints.randomElement()!, amount: 30.00, dateAdded: Date().randomDate),
    Transaction(title: "Electricity Bill", remarks: "Monthly bill", category: .income, tintColor: tints.randomElement()!, amount: 90.00, dateAdded: Date().randomDate),
    Transaction(title: "Clothing Purchase", remarks: "New jeans", category: .expense, tintColor: tints.randomElement()!, amount: 50.00, dateAdded: Date().randomDate),
    Transaction(title: "Weekly Groceries", remarks: "Vegetables and fruits", category: .income, tintColor: tints.randomElement()!, amount: 60.25, dateAdded: Date().randomDate),
    Transaction(title: "Lunch with Friends", remarks: "At Italian restaurant", category: .expense, tintColor: tints.randomElement()!, amount: 80.00, dateAdded: Date().randomDate),
    Transaction(title: "Metro Fare", remarks: "To city center", category: .income, tintColor: tints.randomElement()!, amount: 5.50, dateAdded: Date().randomDate.randomDate),
    Transaction(title: "Concert Tickets", remarks: "Taylor Swift concert", category: .expense, tintColor: tints.randomElement()!, amount: 75.00, dateAdded: Date().randomDate)
]
