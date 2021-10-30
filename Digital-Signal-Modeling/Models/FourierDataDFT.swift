//
//  FourierDataDFT.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 30.10.2021.
//

import Foundation

fileprivate struct FourierSpectrumDataDFT {
    let Aj: Double
    let f: Double

    static func process(values: [Double], j: Int) -> FourierSpectrumDataDFT {
        var Acj: Double = 0
        var Asj: Double = 0
        var Aj: Double = 0
        var f: Double = 0

        let N = Double(values.count)

        for i in 0..<values.count {
            let p = 2.0 * Double.pi * Double(j) * Double(i) / N
            Acj += values[i] * cos(p)
        }
        Acj *= 2.0 / N

        for i in 0..<values.count {
            let p = 2.0 * Double.pi * Double(j) * Double(i) / N
            Asj += values[i] * sin(p)
        }
        Asj *= 2.0 / N
        
        Aj = hypot(Asj, Acj)
        f = atan2(Asj, Acj)

        return FourierSpectrumDataDFT(Aj: Aj, f: f)
    }
}

class FourierDataDFT: FourierData {
    fileprivate let data: [FourierSpectrumDataDFT]

    init(signalValues: [Double]) {
        var data: [FourierSpectrumDataDFT] = []
        for j in 0..<signalValues.count {
            data.append(FourierSpectrumDataDFT.process(values: signalValues, j: j))
        }
        self.data = data
    }

    func getAmplitudeSpectrum() -> [Double] {
        return data.map { $0.Aj }
    }

    func getPhaseSpectrum() -> [Double] {
        return data.map { $0.f }
    }
}
