//
//  Signal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import Foundation

protocol Signal {
    var name: String { get }
    func getValues(_ count: Int) -> [Double]
}
