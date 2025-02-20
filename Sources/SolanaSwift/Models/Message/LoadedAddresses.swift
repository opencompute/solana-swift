//
//  File.swift
//
//
//  Created by Giang Long Tran on 13.01.2023.
//

import Foundation

public typealias AccountKeysFromLookups = LoadedAddresses

public struct LoadedAddresses {
    var readonly: [PublicKey]
    var writable: [PublicKey]

    public init(readonly: [PublicKey], writable: [PublicKey]) {
        self.readonly = readonly
        self.writable = writable
    }
}

public struct MessageAccountKeys {
    public var staticAccountKeys: [PublicKey]
    public var accountKeysFromLookups: AccountKeysFromLookups?

    public init(
        staticAccountKeys: [PublicKey],
        accountKeysFromLookups: AccountKeysFromLookups? = nil
    ) {
        self.staticAccountKeys = staticAccountKeys
        self.accountKeysFromLookups = accountKeysFromLookups
    }

    public var keySegments: [[PublicKey]] {
        var keySegments = [staticAccountKeys]
        if let accountKeysFromLookups = accountKeysFromLookups {
            keySegments.append(accountKeysFromLookups.writable)
            keySegments.append(accountKeysFromLookups.readonly)
        }

        return keySegments
    }

    public subscript(index: Int) -> PublicKey? {
        var index = index

        for keySegment in keySegments {
            if index < keySegment.count {
                return keySegment[index]
            } else {
                index -= keySegment.count
            }
        }
        return nil
    }

    public var count: Int {
        keySegments.reduce([], +).count
    }

    public func compileInstructions(
        instructions: [TransactionInstruction]
    ) throws -> [MessageCompiledInstruction] {
        if count > UInt8.max {
            throw SolanaError.other("Account index overflow encountered during compilation")
        }
        var keyIndexMap: [String: Int] = [:]
        keySegments
            .reduce([], +)
            .enumerated()
            .forEach { index, key in
                keyIndexMap[key.base58EncodedString] = index
            }

        func findKeyIndex(key: PublicKey) throws -> Int {
            if let keyIndex = keyIndexMap[key.base58EncodedString] {
                return keyIndex
            }
            throw SolanaError.other("Encountered an unknown instruction account key during compilation")
        }

        return try instructions.map { (instruction: TransactionInstruction) in
            .init(
                programIdIndex: UInt8(try findKeyIndex(key: instruction.programId)),
                accountKeyIndexes: try instruction.keys.map { meta in UInt8(try findKeyIndex(key: meta.publicKey)) },
                data: instruction.data
            )
        }
    }
}
