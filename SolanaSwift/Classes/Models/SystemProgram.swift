//
//  SystemProgram.swift
//  SolanaSwift
//
//  Created by Chung Tran on 11/6/20.
//

import Foundation

public extension SolanaSDK {
    struct SystemProgram {
        // MARK: - Constraint
        public static let programId = try! PublicKey(string: "11111111111111111111111111111111")
        public static let sysvarRent = try! PublicKey(string: "SysvarRent111111111111111111111111111111111")
        public static let splTokenProgramId = try! PublicKey(string: "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA")
        
        // MARK: - Instructions
        public static func createAccount(
            from fromPublicKey: PublicKey,
            toNewPubkey newPubkey: PublicKey,
            lamports: UInt64,
            space: UInt64 = AccountLayout.span,
            programPubkey: PublicKey
        ) -> Instruction
        {
            let keys = [
                Account.Meta(publicKey: fromPublicKey, isSigner: true, isWritable: true),
                Account.Meta(publicKey: newPubkey, isSigner: true, isWritable: true)
            ]
            
            let data = InstructionType.create.encode([
                lamports,
                space,
                programPubkey
            ])
            return Instruction(keys: keys, programId: programId, data: data.bytes)
        }
        
        public static func assign(account: PublicKey, mint: PublicKey, owner: PublicKey) -> Instruction
        {
            let keys = [
                Account.Meta(publicKey: account, isSigner: false, isWritable: true),
                Account.Meta(publicKey: mint, isSigner: false, isWritable: false),
                Account.Meta(publicKey: owner, isSigner: false, isWritable: false),
                Account.Meta(publicKey: SystemProgram.sysvarRent, isSigner: false, isWritable: false)
            ]
            
            let data = InstructionType.assign.encode([])
            return Instruction(keys: keys, programId: splTokenProgramId, data: data.bytes)
        }
        
        public static func transfer(from fromPublicKey: PublicKey, to toPublicKey: PublicKey, lamports: UInt64) -> Instruction {
            let keys = [
                Account.Meta(publicKey: fromPublicKey, isSigner: true, isWritable: true),
                Account.Meta(publicKey: toPublicKey, isSigner: false, isWritable: true)
            ]
            
            let data = InstructionType.transfer.encode([
                lamports
            ])
            return Instruction(keys: keys, programId: programId, data: data.bytes)
        }
    }
}

extension SolanaSDK.SystemProgram {
    // MARK: - Nested types
    public struct Instruction: Decodable {
        public let keys: [SolanaSDK.Account.Meta]
        public let programId: SolanaSDK.PublicKey
        public let data: [UInt8]
    }
    
    fileprivate enum InstructionType: UInt32 {
        case create                 = 0
        case assign                 = 1
        case transfer               = 2
        case createWithSeed         = 3
        case advanceNonceAccount    = 4
        case withdrawNonceAccount   = 5
        case initializeNonceAccount = 6
        case authorizeNonceAccount  = 7
        case allocate               = 8
        case allocateWithSeed       = 9
        case sssignWithSeed         = 10
        
        private var indexBytes: [UInt8] {
            rawValue.bytes
        }
        
        fileprivate func encode(_ array: [InstructionEncodable]) -> Data {
            var data = Data()
            data.append(contentsOf: indexBytes)
            for el in array {
                data.append(contentsOf: el.instructionEncode())
            }
            return data
        }
    }
}

fileprivate protocol InstructionEncodable {
    func instructionEncode() -> [UInt8]
}

extension Array: InstructionEncodable where Element == UInt8 {
    func instructionEncode() -> [UInt8] {
        self
    }
}

extension UInt64: InstructionEncodable {
    fileprivate func instructionEncode() -> [UInt8] {
        withUnsafeBytes(of: littleEndian, Array.init)
    }
}

extension SolanaSDK.PublicKey: InstructionEncodable {
    fileprivate func instructionEncode() -> [UInt8] {
        bytes
    }
}

