//
//  TransactionCardView.swift
//  Expense Tracker
//
//  Created by Frank Chen on 2024-04-01.
//

import SwiftUI

struct TransactionCardView: View {
    @Environment(\.modelContext) private var modelContext
    var transaction: Transaction
    var showsCategory: Bool = false
    var body: some View {
        SwipeAction(cornerRadius: 10, direction: .trailing, content: {
            HStack(spacing: 12) {
                Text("\(transaction.title.prefix(1))")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(width: 45, height: 45)
                    .background(transaction.color.gradient, in: .circle)
                
                VStack(alignment: .leading, spacing: 4, content: {
                    Text(transaction.title)
                        .foregroundStyle(.primary)
                    
                    Text(transaction.remarks)
                        .font(.caption)
                        .foregroundStyle(.primary.secondary)
                    
                    Text(format(date: transaction.dateAdded, format: "dd MMM yyyy"))
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    if showsCategory {
                        Text(transaction.category)
                            .font(.caption2)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .foregroundStyle(.white)
                            .background(transaction.category == Category.income.rawValue ? Color.green.gradient : Color.red.gradient, in: .capsule)
                    }
                })
                .lineLimit(1)
                .hSpacing(.leading)
                
                Text(currencyString(transaction.amount, allowedDigits: 2))
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.background, in: .rect(cornerRadius: 10))
        }, actions: {
            Action(tint: .red, icon: "trash") {
                // Later
                modelContext.delete(transaction)
            }
        })
    }
}

#Preview {
    TransactionCardView(transaction: sampleTransactions[0])
}
