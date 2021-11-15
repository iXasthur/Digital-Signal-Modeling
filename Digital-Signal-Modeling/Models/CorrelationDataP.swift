//
//  CorrelationDataP.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 15.11.2021.
//

import Foundation

class CorrelationDataP: CorrelationData {
    private let data: [Double]
    private let time: TimeInterval
    
    init(signal0: [Double], signal1: [Double]) {
        if signal0.count != signal1.count {
            fatalError()
        }
        
        var data: [Double] = []
        for i in 0..<signal0.count {
            data.append(CorrelationDataP.corr(signal0[i], signal1[i]))
        }
        
        self.data = data
        self.time = 100
    }
    
    func getValues() -> [Double] {
        return data
    }
    
    func getTime() -> TimeInterval {
        return time
    }
    
    static func corr(_ v0: Double, _ v1: Double) -> Double {
        return -1
    }
}
