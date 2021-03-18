//
//  XCTestCase+Error.swift
//  SnapTests
//
//  Created by Gordon Smith on 18/03/2021.
//

import XCTest

extension XCTestCase {
    func makeError(_ desc: String = "uh oh, something went wrong") -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: desc]
        return NSError(domain: "com.example.error", code: 0, userInfo: userInfo)
    }
}
