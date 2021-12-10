//
//  TransactionRepository.swift
//  Budget
//
//  Created by Billy Brawner on 9/25/19.
//  Copyright © 2019 William Brawner. All rights reserved.
//

import Foundation
import Combine

protocol TransactionRepository {
    func getTransactions(budgetIds: [String], categoryIds: [String]?, from: Date?, to: Date?, count: Int?, page: Int?) -> AnyPublisher<[Transaction], NetworkError>
    func getTransaction(_ transactionId: String) -> AnyPublisher<Transaction, NetworkError>
    func createTransaction(_ transaction: Transaction) -> AnyPublisher<Transaction, NetworkError>
    func updateTransaction(_ transaction: Transaction) -> AnyPublisher<Transaction, NetworkError>
    func deleteTransaction(_ transactionId: String) -> AnyPublisher<Empty, NetworkError>
    func sumTransactions(budgetId: String?, categoryId: String?, from: Date?, to: Date?) -> AnyPublisher<BalanceResponse, NetworkError>
}

#if DEBUG
class MockTransactionRepository: TransactionRepository {
    static let transaction: Transaction = Transaction(
        id: "2",
        title: "Test Transaction",
        description: "A mock transaction used for testing",
        date: Date(),
        amount: 10000,
        categoryId: MockCategoryRepository.category.id,
        expense: true,
        createdBy: MockUserRepository.user.id,
        budgetId: MockBudgetRepository.budget.id
    )

    func getTransactions(budgetIds: [String], categoryIds: [String]?, from: Date?, to: Date?, count: Int?, page: Int?) -> AnyPublisher<[Transaction], NetworkError> {
        return Result.Publisher([MockTransactionRepository.transaction]).eraseToAnyPublisher()
    }
    
    func getTransaction(_ transactionId: String) -> AnyPublisher<Transaction, NetworkError> {
        return Result.Publisher(MockTransactionRepository.transaction).eraseToAnyPublisher()
    }
    
    func createTransaction(_ transaction: Transaction) -> AnyPublisher<Transaction, NetworkError> {
        return Result.Publisher(MockTransactionRepository.transaction).eraseToAnyPublisher()
    }

    func updateTransaction(_ transaction: Transaction) -> AnyPublisher<Transaction, NetworkError> {
        return Result.Publisher(MockTransactionRepository.transaction).eraseToAnyPublisher()
    }
    
    func deleteTransaction(_ transactionId: String) -> AnyPublisher<Empty, NetworkError> {
        return Result.Publisher(.success(Empty())).eraseToAnyPublisher()
    }
    
    func sumTransactions(budgetId: String?, categoryId: String?, from: Date?, to: Date?) -> AnyPublisher<BalanceResponse, NetworkError> {
        return Result.Publisher(.success(BalanceResponse(balance: 1000))).eraseToAnyPublisher()
    }
}
#endif
