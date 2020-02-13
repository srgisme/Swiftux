//
//  Middleware.swift
//  
//
//  Created by Scott Gorden on 2/1/20.
//

import Foundation

/// `Middleware` intercept actions before they reach the `Reducer`. They can perform any kind of work including dispatching new actions to the `Store`, as well as produce side effects. Some examples are logging, caching, and networking. `Middleware` can be "chained" together and even reused across different applications. All `Middleware` should conform to this protocol and be passed inside the `Store` initializer.
public protocol Middleware {
    /// Conforming types should implement this method to perform their work, but you should never call this method directly. This method gets called by the `Store` as actions move through the `Middleware` chain.
    /// - Parameter action: The action being passed in.
    /// - Parameter dispatchFunction: A dispatching function that can be used to dispatch new actions to the `Store`. This will initiate a new flow through the `Middleware` chain.
    /// - Parameter getState: Returns the `Store`'s current state.
    /// - Returns: An action to be passed on to the next `Middleware` or `nil` to drop the action and stop the `Middleware` chain.
    func execute(action: ActionType, dispatchFunction: @escaping (ActionType) -> Void, getState: @escaping () -> StateType?) -> ActionType?
}

extension Sequence where Element == Middleware {
    func execute(action: ActionType, dispatchFunction: @escaping (ActionType) -> Void, getState: @escaping () -> StateType?) -> ActionType? {
        var currentAction = action

        for item in self {
            guard let nextAction = item.execute(action: currentAction, dispatchFunction: dispatchFunction, getState: getState) else {
                return nil
            }
            currentAction = nextAction
        }

        return currentAction
    }
}
