//
//  Quotables.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/15.
//

import Foundation

// MARK: - Quotable
struct Quotable: Codable {
    let id: String
    let author: String
    let content: String
    let tags: [String]
    let authorSlug: String
    let length: Int
    var dateAdded: Date
    let dateModified: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case author, content, tags, authorSlug, length, dateAdded, dateModified
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.author = try container.decode(String.self, forKey: .author)
        self.content = try container.decode(String.self, forKey: .content)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.authorSlug = try container.decode(String.self, forKey: .authorSlug)
        self.length = try container.decode(Int.self, forKey: .length)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateAdded = dateFormatter.date(from: try container.decode(String.self, forKey: .dateAdded)) ?? Date()
        dateModified = dateFormatter.date(from: try container.decode(String.self, forKey: .dateModified)) ?? Date()
    }
    
    func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(id, forKey: .id)
         try container.encode(author, forKey: .author)
         try container.encode(content, forKey: .content)
         try container.encode(tags, forKey: .tags)
         try container.encode(authorSlug, forKey: .authorSlug)
         try container.encode(length, forKey: .length)
         
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         try container.encode(dateFormatter.string(from: dateAdded), forKey: .dateAdded)
         try container.encode(dateFormatter.string(from: dateModified), forKey: .dateModified)
     }
}


