//
//  Store.swift
//  
//
//  Created by Scott Gorden on 2/1/20.
//

import Foundation
import Combine

protocol ActionDispatchable {
    func dispatch(_ action: ActionType)
}

/// Your application should have only one `Store`. You can not subclass it, but it is generic over any app state type you want. Since the `Store` is an `ObservableObject`, any `View`s with an `@ObservedObject` property of this type will automatically be updated any time the `state` changes. If you want to prevent child `View`s from being updated upon `state` changes, wrap the parent `View` in an `EquatableView` (you can use the `equatable()` modifier on the parent as well).
@dynamicMemberLookup
final public class Store<S: StateType & Equatable>: ObservableObject, ActionDispatchable {

    @Published public private(set) var state: S
    var middleware: [Middleware]
    var reducer: Reducer<S>
    private var observedStates: [PartialKeyPath<S> : Any] = [:]

    public init(initialState: S, reducer: @escaping Reducer<S>, middleware: [Middleware]) {
        self.state = initialState
        self.reducer = reducer
        self.middleware = middleware
    }

    public subscript<Substate: StateType & Equatable>(dynamicMember member: KeyPath<S, Substate>) -> ObservedState<S, Substate> {
        guard let observedState = observedStates[member] as? ObservedState<S, Substate> else {
            assertionFailure("Could not retrieve an an object of type ObservedState<\(S.self), \(Substate.self) from observedStates property on Store.")
            let newObservedState = ObservedState(member, on: self)
            observedStates[member] = newObservedState
            return newObservedState
        }
        return observedState
    }
    
    /// This method uses the last action exiting the `Middleware` chain as the action to be passed to the `Reducer`. The `Reducer` uses this action and the current app state to produce a new app state for the `Store`. Sincle the app state is a `@Published` property,
    /// - Parameter action: The action to be dispatched.
    public func dispatch(_ action: ActionType) {
        let dispatchFunction: (ActionType) -> Void = { [weak self] in self?.dispatch($0) }
        let getState = { [weak self] in self?.state }

        guard let lastAction = middleware.execute(action: action, dispatchFunction: dispatchFunction, getState: getState) else {
            return
        }
        
        state = reducer(lastAction, state)
    }

}
