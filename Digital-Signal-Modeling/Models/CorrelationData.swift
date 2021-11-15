//
//  CorrelationData.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 15.11.2021.
//

import Foundation

protocol CorrelationData {
    func getValues() -> [Double]
    func getTimeMs() -> Int
}
