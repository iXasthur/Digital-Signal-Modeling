//
//  CorrelationDataF.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 15.11.2021.
//

import Foundation
import ComplexModule

class CorrelationDataF: CorrelationData {
    private let data: [Double]
    private let time: TimeInterval
    
    init(signal0: [Double], signal1: [Double]) {
        if signal0.count != signal1.count {
            fatalError()
        }
        
        if !signal0.isEmpty {
            let start = Date().timeIntervalSince1970
            self.data = CorrelationDataF.corr(signal0, signal1)
            self.time = Date().timeIntervalSince1970 - start
        } else {
            self.data = []
            self.time = 0
        }
    }
    
    func getValues() -> [Double] {
        return data
    }
    
    func getTimeMs() -> Int {
        return Int(time * 1000)
    }
    
    static func corr(_ v0: [Double], _ v1: [Double]) -> [Double] {
        let v0c = FourierDataFFT.init(signalValues: v0).fftData
        let v1c = FourierDataFFT.init(signalValues: v1).fftData.map { $0.conjugate }
        
        var vc: [Complex<Double>] = []
        
        let n = Complex<Double>.init(v0.count)
        
        for i in 0..<v0c.count {
            vc.append(v0c[i] * v1c[i] / (n * n))
        }
        
        return FourierDataFFT.restoreSignal(from: vc)
    }
}
