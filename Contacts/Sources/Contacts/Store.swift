//
//  Store.swift
//  outliner
//
//  Created by Michael L. Ward on 1/25/18.
//

import Foundation

struct Person: Codable, CustomStringConvertible {
    let first: String
    let last: String
    let dob: Date
    let email: String
    
    static let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    var description: String {
        let bday = Person.formatter.string(from: dob)
        return "\(first) \(last) (\(email)) was born on \(bday)"
    }
}

class PersonStore {
    
    var people = [Person]()
    var url: URL
    
    init?(path: String) {
        url = URL(fileURLWithPath: path)
        guard FileManager.default.fileExists(atPath: path) else {
            return nil
        }
    }
    
    func loadPeople() throws {
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let persons = try decoder.decode(Array<Person>.self, from: data)
        people = persons
    }
    
    func savePeople() throws {        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(people)
        try data.write(to: url)
    }
}
