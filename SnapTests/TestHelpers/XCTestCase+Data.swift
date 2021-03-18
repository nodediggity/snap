//
//  XCTestCase+Data.swift
//  SnapTests
//
//  Created by Gordon Smith on 18/03/2021.
//

import XCTest

extension XCTestCase {
    func makeData(_ value: String = "") -> Data {
        return Data(value.utf8)
    }
}
