//
//  FeedMapper.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import Foundation

enum FeedMapper {
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Post] {
        let decoder = JSONDecoder()
        guard isOK(response), let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.data.asPostDTO
    }
}

private extension FeedMapper {
    
    static var OK_200: Int { 200 }
    
    static func isOK(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode == OK_200
    }
    
    struct Root: Decodable {
        
        let data: [Post]
        
        struct Post: Decodable {
            let id: String
            let image: URL
            let likes: Int
            let owner: User
            
            struct User: Decodable {
                let id: String
                let picture: URL
                let firstName: String
                let lastName: String
            }
        }
    }
}

private extension Array where Element == FeedMapper.Root.Post {
    var asPostDTO: [Post] {
        return map { item in
            return Post(
                id: item.id,
                imageURL: item.image,
                likeCount: item.likes,
                user: Post.User(
                    id: item.owner.id,
                    name: "\(item.owner.firstName) \(item.owner.lastName)",
                    imageURL: item.owner.picture
                )
            )
        }
    }
}
