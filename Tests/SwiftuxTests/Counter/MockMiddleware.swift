//
//  MockMiddleware.swift
//  
//
//  Created by Scott Gorden on 1/10/20.
//

import Foundation
import Swiftux

class MockDispatchingMiddleware: Middleware {

    func execute(action: ActionType, dispatchFunction: @escaping (ActionType) -> Void, getState: @escaping () -> StateType?) -> ActionType? {

        print("evaluating \(action) in middleware")

        if let counterAction = action as? AppAction.CounterAction {
            switch counterAction {
            case .increase:
                dispatchFunction(AppAction.CounterAction.decrease(delta: 1))
                return counterAction
            case .decrease:
                return counterAction
            }
        }

        return action

    }
    
}
