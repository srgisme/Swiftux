//
//  CurrentStateMiddleware.swift
//  
//
//  Created by Scott Gorden on 3/17/20.
//

import Foundation
import Swiftux
import Combine

final class CurrentStateMiddleware: Middleware {
    private var finalCount: Int

    init(finalCount: Int) {
        self.finalCount = finalCount
    }

    func execute(action: ActionType, dispatch: @escaping (ActionType) -> Void, currentStateAfterDispatching: @escaping (ActionType?) -> AnyPublisher<StateType, Never>?) -> ActionType? {

        if case .increase(delta: let delta) = action as? AppAction.CounterAction {

            guard let first = currentStateAfterDispatching(AppAction.CounterAction.decrease(delta: delta)), let second = currentStateAfterDispatching(AppAction.CounterAction.decrease(delta: finalCount)) else {
                return action
            }

            let _ = first
                .append(second)
                .sink { _ in }
        }

        return action

    }

}
