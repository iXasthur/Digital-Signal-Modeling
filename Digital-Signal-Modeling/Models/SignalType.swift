//
//  SignalType.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 25.09.2021.
//

import Foundation

enum SignalType: String, CaseIterable, Identifiable {
    case sine
    case pulse
    case triangle
    case saw
    case noise
    case def

    var id: String { self.rawValue }
}
