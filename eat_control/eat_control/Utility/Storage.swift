//
//  Storage.swift
//  Assistant App
//
//  Created by marsel on 12.02.2021.
//

import Foundation

public class Storage {
    
    public init() { }
    
    public enum Directory {
        // Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
        case documents
        
        // Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
        case caches
    }
    
    /// Returns URL constructed from specified directory
    public static func getURL(for directory: Directory) throws -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
            case .documents:
                searchPathDirectory = .documentDirectory
            case .caches:
                searchPathDirectory = .cachesDirectory
        }
        
        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            throw ErrorModel(description: "Could not create URL for specified directory!")
        }
    }
    
    //
    /// Store an encodable struct to the specified directory on disk
    ///
    /// - Parameters:
    ///   - object: the encodable struct to store
    ///   - directory: where to store the struct
    ///   - fileName: what to name the file where the struct data will be stored
    public static func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String) throws {
        var url: URL?
        do {
            url = try getURL(for: directory)
        } catch {
            print(error.localizedDescription)
        }
        if var url = url {
            url = url.appendingPathComponent(fileName, isDirectory: false)
            do {
                let utility = JSONUtility()
                var data: Data!
                if let app_object = object as? CachedModel {
                    data = utility.create_json(data: app_object)
                }
                if let app_object = object as? [ProfileModel] {
                    data = utility.create_json(data: app_object)
                }
                if let app_object = object as? [DataModel] {
                    data = utility.create_json(data: app_object)
                }
                if FileManager.default.fileExists(atPath: url.path) {
                    try FileManager.default.removeItem(at: url)
                }
                FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            } catch {
                throw ErrorModel(description: error.localizedDescription)
            }
        }
    }
    
    /// Retrieve and convert a struct from a file on disk
    ///
    /// - Parameters:
    ///   - fileName: name of the file where struct data is stored
    ///   - directory: directory where struct data is stored
    ///   - type: struct type (i.e. Message.self)
    /// - Returns: decoded struct model(s) of data
    public static func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) throws -> T? {
        var url: URL?
        do {
            url = try getURL(for: directory)
        } catch {
            print(error.localizedDescription)
        }
        if var url = url {
            url = url.appendingPathComponent(fileName, isDirectory: false)
            if !FileManager.default.fileExists(atPath: url.path) { throw ErrorModel(description: "No file at \(url.path)!") }
            let utility = JSONUtility()
            if let data = FileManager.default.contents(atPath: url.path) {
                var result_data: Any!
                if type == CachedModel.self {
                    if let app_data = utility.parse_cache(app_data: data) {
                        result_data = app_data
                    }
                }
                if type == [DataModel].self {
                    if let app_data = utility.parse_data(app_data: data) {
                        result_data = app_data
                    }
                }
                if type == [ProfileModel].self {
                    if let app_data = utility.parse_profile(app_data: data) {
                        result_data = app_data
                    }
                }
                return result_data as? T
            } else {
                throw ErrorModel(description: "No data at \(url.path)!")
            }
        } else {
            return nil
        }
    }
    
    /// Retrieve and convert a struct from a file on disk
    ///
    /// - Parameters:
    ///   - fileName: name of the file where struct data is stored
    ///   - directory: directory where struct data is stored
    ///   - type: struct type (i.e. Message.self)
    /// - Returns: decoded struct model(s) of data
//    public static func retrieve(_ fileName: String, from directory: Directory) throws -> Data? {
//        var url: URL?
//        do {
//            url = try getURL(for: directory)
//        } catch {
//            print(error.localizedDescription)
//        }
//        if var url = url {
//            url = url.appendingPathComponent(fileName, isDirectory: false)
//            if !FileManager.default.fileExists(atPath: url.path) { }
//            if let data = FileManager.default.contents(atPath: url.path) {
//                return data
//            } else {
//                throw ErrorModel(description: "No data at \(url.path)!")
//            }
//        } else {
//            return nil
//        }
//    }
    
    /// Remove all files at specified directory
    public static func clear(_ directory: Directory) {
        var url: URL?
        do {
            url = try getURL(for: directory)
        } catch {
            print(error.localizedDescription)
        }
        if let url = url {
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
                for fileUrl in contents {
                    try FileManager.default.removeItem(at: fileUrl)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    /// Remove specified file from specified directory
    public static func remove(_ fileName: String, from directory: Directory) throws {
        var url: URL?
        do {
            url = try getURL(for: directory)
        } catch {
            print(error.localizedDescription)
        }
        if var url = url {
            url = url.appendingPathComponent(fileName, isDirectory: false)
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    throw ErrorModel(description: error.localizedDescription)
                }
            }
        }
    }
    
    /// Returns BOOL indicating whether file exists at specified directory with specified file name
    public static func fileExists(_ fileName: String, in directory: Directory) -> Bool {
        var url: URL?
        do {
            url = try getURL(for: directory)
        } catch {
            print(error.localizedDescription)
        }
        if var url = url {
            url = url.appendingPathComponent(fileName, isDirectory: false)
            return FileManager.default.fileExists(atPath: url.path)
        } else {
            return false
        }
    }
    
    static func writeData(json_data: [DataModel]?) {
        let file_name = "data.json"
        do {
            print("Create json data...")
            try Storage.store(json_data, to: .documents, as: file_name)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func writeProfiles(json_data: [ProfileModel]?) {
        let file_name = "profile_data.json"
        do {
            print("Create json data...")
            try Storage.store(json_data, to: .documents, as: file_name)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func removeProfile(name: String) {
        var json_data: [ProfileModel]?
        json_data = self.readProfiles()
        print("Remove item from json...")
        json_data?.removeAll(where: {$0.name == name})
        Storage.writeProfiles(json_data: json_data)
    }
    
    static func readProfiles() -> [ProfileModel]? {
        var json_data: [ProfileModel]?
        let file_name = "profile_data.json"
        do {
            print("Read json data...")
            json_data = try Storage.retrieve(file_name, from: .documents, as: [ProfileModel].self)
            print(json_data)
        } catch {
            print(error.localizedDescription)
        }
        return json_data
    }
    
}
