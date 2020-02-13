//
//  File.swift
//  
//
//  Created by Scott Gorden on 12/30/19.
//

import Foundation
import Swiftux

struct AppAction {
    enum CounterAction: ActionType {
        case increase(delta: Int), decrease(delta: Int)
    }
}
