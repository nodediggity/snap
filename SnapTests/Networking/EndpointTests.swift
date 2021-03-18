//
//  EndpointTests.swift
//  SnapTests
//
//  Created by Gordon Smith on 18/03/2021.
//

import XCTest
@testable import Snap

class EndpointTests: XCTestCase {

    func test_sets_host_value_for_url() {
        let host = "api.domain.tld"
        let sut = Endpoint(host: host)
        XCTAssertEqual(sut.url.host, host)
    }
    
    func test_maps_path_for_url() {
        let path = ["some", "path"]
        let sut = Endpoint(host: "api.domain.tld", path: path)
        XCTAssertEqual(sut.url.path, "/some/path")
    }
    
    func test_maps_query_items_for_url() {
        let host = "api.domain.tld"
        let sut = Endpoint(host: host, queryItems: ["some_key": "some_value"])
        XCTAssertEqual(sut.url.query, "some_key=some_value")
    }
    
    func test_maps_duplicate_query_item_keys() {
        let host = "api.domain.tld"
        let sut = Endpoint(host: host, queryItems: ["some_key": "some_value", "some_key": "some_other_value"])
        XCTAssertEqual(sut.url.query, "some_key=some_value&some_key=some_other_value")
    }

}

