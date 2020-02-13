//
//  File.swift
//  
//
//  Created by Scott Gorden on 12/30/19.
//

import Foundation
import Swiftux

let counterReducer: Reducer<MockCounterState> = { action, state in

    guard let counterAction = action as? AppAction.CounterAction else {
        return state
    }

    var state = state

    switch counterAction {
    case .increase(let delta):
        state.count += delta
    case .decrease(delta: let delta):
        state.count -= delta
    }

    return state

}

let appReducer: Reducer<MockAppState> = { action, state in

    var state = state

    switch action {
    case let counterAction as AppAction.CounterAction:
        state.counterState = counterReducer(counterAction, state.counterState)
    default:
        return state
    }

    return state

}
