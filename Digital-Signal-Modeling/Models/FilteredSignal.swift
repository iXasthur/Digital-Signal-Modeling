//
//  FilteredSignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 30.10.2021.
//

import Foundation

struct FilteredSignal: BaseSignal {
    let name: String = "Filtered signal"
    
    let signal: BaseSignal
    
    var leftBound: Double = 0
    var rightBound: Double = 440
    
    init(signal: BaseSignal) {
        self.signal = signal
    }
    
    func getValues(_ count: Int) -> [Double] {
        return filter(signal.getValues(count))
    }
    
    private func filter(_ values: [Double]) -> [Double] {
        let fourierData = FourierDataFFT(signalValues: values)
        
        var phaseSpectrum = fourierData.getPhaseSpectrum()
        var amplitudeSpectrum = fourierData.getAmplitudeSpectrum()
        for i in 0..<amplitudeSpectrum.count {
            let index: Double
            if i > amplitudeSpectrum.count / 2 {
                index = Double(amplitudeSpectrum.count - i)
            } else {
                index = Double(i)
            }
            
            if index < leftBound || index > rightBound {
                phaseSpectrum[i] = 0
                amplitudeSpectrum[i] = 0
            }
        }
        
        return FourierDataFFT.restoreSignal(
            amplitudeSpectrum: amplitudeSpectrum,
            phaseSpectrum: phaseSpectrum
        )
    }
}
