//
//  ViewState.swift
//  Snap
//
//  Created by Gordon Smith on 20/03/2021.
//

import Foundation

enum ViewState<T: Equatable>: Equatable {
    case loading
    case loaded(T)
    case error(message: String?)
}
