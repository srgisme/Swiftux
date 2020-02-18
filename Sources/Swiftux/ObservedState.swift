//
//  ObservedState.swift
//  
//
//  Created by Scott Gorden on 2/17/20.
//

import Foundation
import Combine

public class ObservedState<RootState: StateType & Equatable, Substate: StateType & Equatable>: ObservableObject, ActionDispatchable {

    private unowned var store: Store<RootState>
    private var keyPathToSubstate: KeyPath<RootState, Substate>
    private var cancellable: AnyCancellable?

    public var objectWillChange = ObservableObjectPublisher()
    public var value: Substate {
        store.state.value[keyPath: keyPathToSubstate]
    }

    public init(_ keyPathToSubstate: KeyPath<RootState, Substate>, on store: Store<RootState>) {
        self.store = store
        self.keyPathToSubstate = keyPathToSubstate
        self.cancellable = store.state
            .map { $0[keyPath: keyPathToSubstate] }
            .removeDuplicates()
            .sink { _ in
                self.objectWillChange.send()
            }
    }

    public func dispatch(_ action: ActionType) {
        store.dispatch(action)
    }

    deinit {
        cancellable?.cancel()
    }

}
