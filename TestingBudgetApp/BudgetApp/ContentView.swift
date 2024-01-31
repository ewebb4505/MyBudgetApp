//
//  ContentView.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/1/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("View All Transactions") {
                        TransactionsListView()
                    }
                    
                    NavigationLink("Add Transactions") {
                        AddTransactionsView()
                    }
                    
                    NavigationLink("Delete Transaction") {
                        DeleteTransactionView()
                    }
                }
                
                Section {
                    NavigationLink("View All Tags") {
                        GetAllTagsView()
                    }
                    
                    NavigationLink("Create Tags") {
                        CreateTagView()
                    }
                    
                    NavigationLink("Delete A Tag") {
                        DeleteTagView()
                    }
                }
                
                Section {
                    NavigationLink("Add Tags To Transactions") {
                        AddTagsToTransactionView()
                    }
                } header: {
                    Text("Transactions + Tags")
                }
                
                Section {
                    NavigationLink("Add Transactions To Budget Category") {
                        AddTransactionToBudgetCategoryView()
                    }
                } header: {
                    Text("Transactions + Tags")
                }
                
                Section {
                    NavigationLink {
                        CreateBudgetView()
                            .navigationTitle("Create Budget")
                    } label: {
                        
                        Text("Create A Budget")
                    }
                    
                    NavigationLink {
                        CreateBudgetCategoryView()
                            .navigationTitle("Budget Category")
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Create A Budget Category")
                            Text("must have a budget created.")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                } header: {
                    Text("Budgeting")
                }

            }
            .navigationTitle("Budget App")
        }
    }
}
