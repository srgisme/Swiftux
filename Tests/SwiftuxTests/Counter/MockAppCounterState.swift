//
//  MockCounterState.swift
//  
//
//  Created by Scott Gorden on 12/30/19.
//

import Foundation
import Swiftux

struct MockAppState: StateType, Equatable {
    var counterState = MockCounterState()
}

struct MockCounterState: StateType, Equatable {
    var count: Int = 0
}
