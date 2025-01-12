//
//  Search.swift
//  Expense Tracker
//
//  Created by Frank Chen on 2024-04-01.
//

import SwiftUI
import Combine

struct Search: View {
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    @State private var selectedCategory: Category? = nil
    let searchPublisher = PassthroughSubject<String, Never>()
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    FilterTransactionsView(category: selectedCategory, searchText: filterText) { transaction in
                        ForEach(transaction) { transaction in
                            NavigationLink {
                                TransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction, showsCategory: true)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(15)
            }
            .overlay {
                ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
                    .opacity(filterText.isEmpty ? 1: 0)
            }
            .onChange(of: searchText, { oldValue, newValue in
                if newValue.isEmpty {
                    filterText = ""
                }
                searchPublisher.send(newValue)
            })
            .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: { text in
                filterText = text
            })
            .searchable(text: $searchText)
            .navigationTitle("Search")
            .background(.gray.opacity(0.15))
            .toolbar {
               ToolBarContent()
            }
        }
    }
    
    @ViewBuilder
    func ToolBarContent() -> some View {
        Menu {
            Button(action: {
                selectedCategory = nil
            }, label: {
                HStack {
                    Text("Both")
                    
                    if selectedCategory == nil {
                        Image(systemName: "checkmark")
                    }
                }
            })
            
            ForEach(Category.allCases, id: \.rawValue) { category in
                Button(action: {
                    selectedCategory = category
                }, label: {
                    HStack {
                        Text(category.rawValue)
                        
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                        }
                    }
                })
            }
        } label: {
            Image(systemName: "slider.vertical.3")
        }
    }
}

#Preview {
    Search()
}
