//
//  JSONHelper.swift
//  Booster App
//
//  Created by marsel on 12.02.2021.
//

import Foundation

public class JSONUtility {
    
    public init() {}
    
    public func parse_profile(app_data: Data) -> [ProfileModel]? {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode([ProfileModel].self, from: app_data)
            return data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func parse_data(app_data: Data) -> [DataModel]? {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode([DataModel].self, from: app_data)
            return data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func parse_cache(app_data: Data) -> CachedModel? {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(CachedModel.self, from: app_data)
            return data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func create_json(data: [ProfileModel]) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let json_data = try encoder.encode(data)
            return json_data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func create_json(data: CachedModel) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let json_data = try encoder.encode(data)
            return json_data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func create_json(data: [DataModel]) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let json_data = try encoder.encode(data)
            return json_data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}
