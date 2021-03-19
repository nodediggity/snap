//
//  Post.swift
//  Snap
//
//  Created by Gordon Smith on 18/03/2021.
//

import Foundation

struct Post: Hashable {
    
    let id: String
    let imageURL: URL
    let likeCount: Int
    let user: User
    
    struct User: Hashable {
        let id: String
        let name: String
        let imageURL: URL
    }
}

extension Post: Identifiable { }
