//
//  HTTPURLResponse+Ext.swift
//  SnapTests
//
//  Created by Gordon Smith on 18/03/2021.
//

import Foundation

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: URL(string: "https://any-url.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
