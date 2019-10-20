
//
//  BudgetsView.swift
//  Budget
//
//  Created by Billy Brawner on 9/30/19.
//  Copyright © 2019 William Brawner. All rights reserved.
//

import SwiftUI
import Combine

struct BudgetListsView: View {
    @ObservedObject var budgetsDataStore: BudgetsDataStore
    
    var body: some View {
        NavigationView {
            stateContent.navigationBarTitle("budgets")
        }
    }
    
    var stateContent: AnyView {
        switch budgetsDataStore.budgets {
        case .success(let budgets):
            return AnyView(
                Section {
                    List(budgets) { budget in
                        BudgetListItemView(self.dataStoreProvider, budget: budget)
                    }
                }
            )
        case .failure(.loading):
            return AnyView(VStack {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            })
        default:
            // TODO: Handle each network failure type
            return AnyView(Text("budgets_load_failure"))
        }
    }
    
    let dataStoreProvider: DataStoreProvider
    init(_ dataStoreProvider: DataStoreProvider) {
        self.dataStoreProvider = dataStoreProvider
        self.budgetsDataStore = dataStoreProvider.budgetsDataStore()
        self.budgetsDataStore.getBudgets()
    }
}

struct BudgetListItemView: View {
    var budget: Budget
    let dataStoreProvider: DataStoreProvider
    
    var body: some View {
        NavigationLink(
            destination: BudgetDetailsView(self.dataStoreProvider, budget: budget)
                .navigationBarTitle(budget.name)
        ) {
            VStack(alignment: .leading) {
                Text(verbatim: budget.name)
                    .lineLimit(1)
                if budget.description?.isEmpty == false {
                    Text(verbatim: budget.description!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
    }
    
    init (_ dataStoreProvider: DataStoreProvider, budget: Budget) {
        self.dataStoreProvider = dataStoreProvider
        self.budget = budget
    }
}

#if DEBUG
struct BudgetListsView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListsView(MockDataStoreProvider())
    }
}
#endif