//
//  MockMiddleware.swift
//  
//
//  Created by Scott Gorden on 1/10/20.
//

import Foundation
import Swiftux
import Combine

class MockDispatchingMiddleware: Middleware {
    func execute(action: ActionType, dispatch: @escaping (ActionType) -> Void, currentStateAfterDispatching: @escaping (ActionType?) -> AnyPublisher<StateType, Never>?) -> ActionType? {

        print("evaluating \(action) in middleware")

        if let counterAction = action as? AppAction.CounterAction {
            switch counterAction {
            case .increase:
                dispatch(AppAction.CounterAction.decrease(delta: 1))
                return counterAction
            case .decrease:
                return counterAction
            }
        }

        return action

    }
}
