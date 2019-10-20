//
//  BudgetRepository.swift
//  Budget
//
//  Created by Billy Brawner on 9/30/19.
//  Copyright © 2019 William Brawner. All rights reserved.
//

import Foundation
import Combine

protocol BudgetRepository {
    func getBudgets(count: Int?, page: Int?) -> AnyPublisher<[Budget], NetworkError>
    func getBudget(_ id: Int) -> AnyPublisher<Budget, NetworkError>
    func getBudgetBalance(_ id: Int) -> AnyPublisher<Int, NetworkError>
    func newBudget(_ budget: Budget) -> AnyPublisher<Budget, NetworkError>
    func updateBudget(_ budget: Budget) -> AnyPublisher<Budget, NetworkError>
    func deleteBudget(_ id: Int) -> AnyPublisher<Empty, NetworkError>
}

class NetworkBudgetRepository: BudgetRepository {
    let apiService: BudgetAppApiService
    let cacheService: BudgetAppInMemoryCacheService?
    
    init(_ apiService: BudgetAppApiService, cacheService: BudgetAppInMemoryCacheService? = nil) {
        self.apiService = apiService
        self.cacheService = cacheService
    }
    
    func getBudgets(count: Int?, page: Int?) -> AnyPublisher<[Budget], NetworkError> {
        if let budgets = cacheService?.getBudgets(count: count, page: page) {
            return budgets
        }
        
        return apiService.getBudgets(count: count, page: page).map { (budgets: [Budget]) in
            self.cacheService?.addBudgets(budgets)
            return budgets
        }.eraseToAnyPublisher()
    }
    
    func getBudget(_ id: Int) -> AnyPublisher<Budget, NetworkError> {
        if let budget = cacheService?.getBudget(id) {
            return budget
        }
        return apiService.getBudget(id).map { budget in
            self.cacheService?.addBudget(budget)
            return budget
        }.eraseToAnyPublisher()
    }
    
    func getBudgetBalance(_ id: Int) -> AnyPublisher<Int, NetworkError> {
        return apiService.getBudgetBalance(id)
    }
    
    func newBudget(_ budget: Budget) -> AnyPublisher<Budget, NetworkError> {
        return apiService.newBudget(budget)
    }
    
    func updateBudget(_ budget: Budget) -> AnyPublisher<Budget, NetworkError> {
        return apiService.updateBudget(budget)
    }
    
    func deleteBudget(_ id: Int) -> AnyPublisher<Empty, NetworkError> {
        return apiService.deleteBudget(id)
    }
}

#if DEBUG

class MockBudgetRepository: BudgetRepository {
    static let budget = Budget(
        id: 1,
        name: "Test Budget",
        description: "A mock budget used for testing",
        users: []
    )
    
    func getBudgets(count: Int?, page: Int?) -> AnyPublisher<[Budget], NetworkError> {
        return Result.Publisher([MockBudgetRepository.budget]).eraseToAnyPublisher()
    }
    
    func getBudget(_ id: Int) -> AnyPublisher<Budget, NetworkError> {
        return Result.Publisher(MockBudgetRepository.budget).eraseToAnyPublisher()
    }
    
    func getBudgetBalance(_ id: Int) -> AnyPublisher<Int, NetworkError> {
        return Result.Publisher(10000).eraseToAnyPublisher()
    }
    
    func newBudget(_ budget: Budget) -> AnyPublisher<Budget, NetworkError> {
        return Result.Publisher(MockBudgetRepository.budget).eraseToAnyPublisher()
    }
    
    func updateBudget(_ budget: Budget) -> AnyPublisher<Budget, NetworkError> {
        return Result.Publisher(Budget(
            id: 1,
            name: "Test Budget",
            description: "A mock budget used for testing",
            users: []
        )).eraseToAnyPublisher()
    }
    
    func deleteBudget(_ id: Int) -> AnyPublisher<Empty, NetworkError> {
        return Result.Publisher(Empty()).eraseToAnyPublisher()
    }
}

#endif