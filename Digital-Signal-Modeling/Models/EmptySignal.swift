//
//  EmptySignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 15.11.2021.
//

import Foundation

struct EmptySignal: BaseSignal {
    var name: String = "Empty"
    
    func getValues(_ count: Int) -> [Double] {
        return []
    }
}
