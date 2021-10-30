//
//  BaseSignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 28.10.2021.
//

import Foundation

protocol BaseSignal {
    var name: String { get }
    func getValues(_ count: Int) -> [Double]
    func getValuesF(_ count: Int) -> [Float]
}

extension BaseSignal {
    func getValuesF(_ count: Int) -> [Float] {
        var fvalues: [Float] = []
        self.getValues(count).forEach { v in
            fvalues.append(Float(v))
        }
        return fvalues
    }
}
