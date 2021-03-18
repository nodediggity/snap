//
//  FeedMapperTests.swift
//  SnapTests
//
//  Created by Gordon Smith on 18/03/2021.
//

import XCTest
@testable import Snap

class FeedMapperTests: XCTestCase {
    
    func test_map_throws_error_on_non_200_HTTPResponse() throws {
        let json = makeItemsJSON(for: [])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
        func test_map_throws_error_on_200_HTTPResponse_with_invalid_json() {
            let invalidJSON = Data("invalid json".utf8)
    
            XCTAssertThrowsError(
                try FeedMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
            )
        }
    
        func test_map_delivers_no_items_on_200_HTTPResponse_with_empty_json_list() throws {
            let emptyListJSON = makeItemsJSON(for: [])
    
            let result = try FeedMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
    
            XCTAssertEqual(result, [])
        }
    
        func test_map_delivers_items_on_200_HTTPResponse_with_json_items() throws {
            let feed = makeFeed(itemCount: 1)
            let feedModel = feed.map(\.model)
            let feedJSON = makeItemsJSON(for: feed.map(\.json))
    
            let result = try FeedMapper.map(feedJSON, from: HTTPURLResponse(statusCode: 200))
    
            XCTAssertEqual(result, feedModel)
        }
    
}

private extension FeedMapperTests {
    
    func makeItemsJSON(for items: [[String: Any]]) -> Data {
        let data = try! JSONSerialization.data(withJSONObject: [
            "data": items
        ])
        return data
    }
    
    func makeFeed(itemCount: Int = 5) -> [(model: Post, json: [String: Any])] {
        return (0..<itemCount).map { _ in makeItem() }
    }
    
    func makeItem() -> (model: Post, json: [String: Any]) {
        let postID = UUID().uuidString
        let userID = UUID().uuidString
        
        let model = Post(
            id: postID,
            imageURL: makeURL("https://img.dummyapi.io/photo-1564694202779-bc908c327862.jpg"),
            likeCount: 5,
            user: Post.User(id: userID, name: "any name", imageURL: makeURL("https://randomuser.me/api/portraits/women/93.jpg"))
        )
        
        let json =  [
            "owner": [
                "id": userID,
                "picture": "https://randomuser.me/api/portraits/women/93.jpg",
                "firstName": "any",
                "lastName": "name"
            ],
            "id": postID,
            "image": "https://img.dummyapi.io/photo-1564694202779-bc908c327862.jpg",
            "likes": 5
        ] as [String : Any]
     
        
        return (model, json)
    }
}
