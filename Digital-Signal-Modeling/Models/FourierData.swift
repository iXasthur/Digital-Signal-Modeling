//
//  FourierData.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 30.10.2021.
//

import Foundation

struct FourierHarmonicData {
    let Acj: Double
    let Asj: Double
    let Aj: Double
    let f: Double

    static func process(values: [Double], j: Int) -> FourierHarmonicData {
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

        return FourierHarmonicData(Acj: Acj, Asj: Asj, Aj: Aj, f: f)
    }
}

class FourierData {
    let data: [FourierHarmonicData]

    init(signalValues: [Double]) {
        var data: [FourierHarmonicData] = []
        for j in 0..<signalValues.count {
            data.append(FourierHarmonicData.process(values: signalValues, j: j))
        }
        self.data = data
    }

    func getAmplitudeSpectrum() -> [Double] {
        return data.map { $0.Aj }
    }

    func getPhaseSpectrum() -> [Double] {
        return data.map { $0.f }
    }

    func getRestoredSignal() -> [Double] {
        let amplitudeSpectrum = getAmplitudeSpectrum()
        let phaseSpectrum = getPhaseSpectrum()

        let N = Double(data.count)

        var values: [Double] = []

        for i in 0..<data.count {
            var value: Double = 0

            var sum: Double = 0
            for j in 1..<(data.count / 2) {
                let p = 2.0 * Double.pi * Double(j) * Double(i) / N
                sum += amplitudeSpectrum[j] * cos(p - phaseSpectrum[j])
            }

            value = (amplitudeSpectrum[0] / 2) + sum

            values.append(value)
        }

        return values
    }
    
    func getRestoredSignalIgnoringPhase() -> [Double] {
        let amplitudeSpectrum = getAmplitudeSpectrum()

        let N = Double(data.count)

        var values: [Double] = []

        for i in 0..<data.count {
            var value: Double = 0

            var sum: Double = 0
            for j in 1..<(data.count / 2) {
                let p = 2.0 * Double.pi * Double(j) * Double(i) / N
                sum += amplitudeSpectrum[j] * cos(p)
            }

            value = (amplitudeSpectrum[0] / 2) + sum

            values.append(value)
        }

        return values
    }
}
