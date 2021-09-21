//
//  SignalType.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import Foundation

enum SignalType: String, CaseIterable, Identifiable {
    case sine
    case impulse
    case triangle
    case saw
    case noise

    var id: String { self.rawValue }
}
