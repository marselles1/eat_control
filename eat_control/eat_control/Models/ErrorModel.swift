//
//  ErrorModel.swift
//  eat_control
//
//  Created by marsel on 12.02.2021.
//

import Foundation

public struct ErrorModel: LocalizedError, Equatable {
    
    private var description: String!

    public init(description: String) {
        self.description = description
    }

    public var errorDescription: String? {
        return description
    }

    public static func ==(lhs: ErrorModel, rhs: ErrorModel) -> Bool {
        return lhs.description == rhs.description
    }
    
}
