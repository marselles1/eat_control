//
//  UserModel.swift
//  eat_control
//
//  Created by marsel on 12.02.2021.
//

import Foundation

public struct ProfileModel: Codable {
    
    var name: String!
    var age: Int!
    var password: String!
    
    var daily_insulin_dose: String!
    var breakfast: String!
    var lunch: String!
    var dinner: String!
    
}
