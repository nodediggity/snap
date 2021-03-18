//
//  XCTestCase+URL.swift
//  SnapTests
//
//  Created by Gordon Smith on 18/03/2021.
//

import XCTest

extension XCTestCase {
    func makeURL(_ str: String = "https://any-given-url.com") -> URL {
        return URL(string: str)!
    }
}
