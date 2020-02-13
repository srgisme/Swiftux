//
//  MockCounterState.swift
//  
//
//  Created by Scott Gorden on 12/30/19.
//

import Foundation
import Swiftux

struct MockAppState: StateType {
    var counterState: MockCounterState = MockCounterState()
}

struct MockCounterState: StateType {
    var count: Int = 0
}
