//
//  FourierData.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 30.10.2021.
//

import Foundation

protocol FourierData {
    func getAmplitudeSpectrum() -> [Double]
    func getPhaseSpectrum() -> [Double]
}

extension FourierData {
    func getRestoredSignal() -> [Double] {
        let amplitudeSpectrum = getAmplitudeSpectrum()
        let phaseSpectrum = getPhaseSpectrum()
        
        if amplitudeSpectrum.count != phaseSpectrum.count {
            fatalError()
        }
        
        let count = amplitudeSpectrum.count

        let N = Double(count)

        var values: [Double] = []

        for i in 0..<count {
            var value: Double = 0

            var sum: Double = 0
            for j in 1..<(count / 2) - 1 {
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

        let count = amplitudeSpectrum.count
        
        let N = Double(count)

        var values: [Double] = []

        for i in 0..<count {
            var value: Double = 0

            var sum: Double = 0
            for j in 1..<(count / 2) {
                let p = 2.0 * Double.pi * Double(j) * Double(i) / N
                sum += amplitudeSpectrum[j] * cos(p)
            }

            value = (amplitudeSpectrum[0] / 2) + sum

            values.append(value)
        }

        return values
    }
}
