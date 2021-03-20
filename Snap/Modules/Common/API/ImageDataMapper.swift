//
//  ImageDataMapper.swift
//  Snap
//
//  Created by Gordon Smith on 20/03/2021.
//

import Foundation

final class ImageDataMapper {
    enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard isOK(response), !data.isEmpty else {
            throw Error.invalidData
        }
        
        return data
    }
}

private extension ImageDataMapper {
    
    static var OK_200: Int { 200 }
    
    static func isOK(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode == OK_200
    }
}

