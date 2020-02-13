//
//  ActionType.swift
//  
//
//  Created by Scott Gorden on 2/1/20.
//

import Foundation

/// Actions contain values a `Reducer` needs in order to modify state. They are dispatched to the `Store` and acted upon by `Middleware`. All actions should conform to this protocol.
public protocol ActionType { }
