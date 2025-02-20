//
//  NSRegularExpression+Extensions.swift
//  SolanaSwift
//
//  Created by Chung Tran on 18/11/2020.
//

import Foundation

public extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }

    static let publicKey = try! NSRegularExpression(pattern: #"^[1-9A-HJ-NP-Za-km-z]{32,44}$"#)
}
