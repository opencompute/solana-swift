//
//  PreparedVersionedTransaction.swift
//
//
//  Created by Giang Long Tran on 02.04.2023.
//

import Foundation

/// The prepared transaction that can be sent or simulate in SolanaBlockchainClient
public struct PreparedVersionedTransaction: Equatable {
    public var transaction: VersionedTransaction
    public var expectedFee: FeeAmount

    public init(transaction: VersionedTransaction, expectedFee: FeeAmount) {
        self.transaction = transaction
        self.expectedFee = expectedFee
    }
}
