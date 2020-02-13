//
//  Reducer.swift
//  
//
//  Created by Scott Gorden on 2/1/20.
//

import Foundation

/// A pure function, which takes an action and some state that returns a new state of the same type. The `Store` uses a `Reducer` to modify its state.
/// - Parameter action: Some action.
/// - Parameter state: Some state.
/// - Returns: A new state.
public typealias Reducer<S: StateType> = (_ action: ActionType, _ state: S) -> S
