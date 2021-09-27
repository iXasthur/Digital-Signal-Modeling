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
    func getValuesF(_ count: Int) -> [Float]
}

extension Signal {
    func getValuesF(_ count: Int) -> [Float] {
        var fvalues: [Float] = []
        self.getValues(count).forEach { v in
            fvalues.append(Float(v))
        }
        return fvalues
    }
}
