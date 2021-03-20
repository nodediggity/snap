//
//  ImageDataMapperTests.swift
//  SnapTests
//
//  Created by Gordon Smith on 20/03/2021.
//

import XCTest

@testable import Snap

class ImageDataMapperTests: XCTestCase {

    func test_map_throws_error_on_non_200_HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageDataMapper.map(makeData(), from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_delivers_invalid_data_error_on_200_HTTPResponse_with_empty_data() {
        let emptyData = makeData()
        XCTAssertThrowsError(
            try ImageDataMapper.map(emptyData, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_delivers_receive_non_empty_data_on_200_HTTPResponse() throws {
        let nonEmptyData = makeData("non-empty data")
        let result = try ImageDataMapper.map(nonEmptyData, from: HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, nonEmptyData)
    }
}
