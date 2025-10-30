//
//  StoreManager.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import Foundation
import StoreKit

enum StoreError: Error {
    case failedVerification
    case purchasePending
    case userCancelled
}

@MainActor
class StoreManager {
    
    static let shared = StoreManager()
    
    private let productIDs = ["com.guruapps.test.monthly"]
    private(set) var products: [Product] = []
    private(set) var isSubscribed: Bool = false
    private var transactionListener: Task<Void, Error>? = nil
    
    private init() {
        transactionListener = listenForTransactions()
    }
    
    func fetchProducts() async throws {
        do {
            let loadedProducts = try await Product.products(for: productIDs)
            self.products = loadedProducts
            LogService.log("✅ Продукты успешно загружены.")
        } catch {
            LogService.log("❌ Не удалось загрузить продукты: \(error)", type: .error)
            throw error
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    self.isSubscribed = true
                    await transaction.finish()
                    LogService.log("✅ Покупка успешна (ID: \(transaction.id))")
                    return transaction
                case .unverified:
                    throw StoreError.failedVerification
                }
                
            case .pending:
                throw StoreError.purchasePending
                
            case .userCancelled:
                throw StoreError.userCancelled
                
            @unknown default:
                throw StoreError.userCancelled
            }
        } catch StoreKitError.userCancelled {
            throw StoreError.userCancelled
        } catch {
            throw error
        }
    }
    
    private func updateSubscriptionStatus(for transaction: Transaction) async {
        isSubscribed = true
        LogService.log("Статус подписки обновлен.")
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    LogService.log("--- Обновление транзакции (ID: \(transaction.productID))")
                    await self.updateSubscriptionStatus(for: transaction)
                    await transaction.finish()
                case .unverified:
                    break
                }
            }
        }
    }
    
    func restorePurchases() async throws {
        try await AppStore.sync()
        LogService.log("✅ Запрос на восстановление покупок отправлен.")
    }
}
