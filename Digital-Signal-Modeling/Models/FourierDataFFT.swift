//
//  FourierDataFFT.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 30.10.2021.
//

import Foundation
import ComplexModule

fileprivate struct FourierSpectrumDataFFT {
    let Aj: Double
    let f: Double

    static func process(fftValues: [Complex<Double>]) -> [FourierSpectrumDataFFT] {
        var data: [FourierSpectrumDataFFT] = []
        fftValues.forEach { fftV in
            let Aj: Double = fftV.length * 2 / Double(fftValues.count)
            var f: Double = -atan2(fftV.imaginary, fftV.real)
            if Aj < FourierDataFFT.threshold {
                f = 0
            }
            data.append(FourierSpectrumDataFFT(Aj: Aj, f: f))
        }
        return data
    }
}

class FourierDataFFT: FourierData {
    fileprivate let data: [FourierSpectrumDataFFT]
    let fftData: [Complex<Double>]
    
    fileprivate init(fftData: [Complex<Double>]) {
        self.fftData = fftData
        data = FourierSpectrumDataFFT.process(fftValues: self.fftData)
    }
    
    convenience init(signalValues: [Double]) {
        var values: [Complex<Double>] = []
        signalValues.forEach { value in
            values.append(Complex<Double>(value))
        }
        
        FourierDataFFT.fft(&values)
        
        self.init(fftData: values)
    }
    
    func getAmplitudeSpectrum() -> [Double] {
        return data.map { $0.Aj }
    }

    func getPhaseSpectrum() -> [Double] {
        return data.map { $0.f }
    }
    
    // Faster than default implementation
    func getRestoredSignal() -> [Double] {
        var data = fftData
        FourierDataFFT.fft(&data)
        return data.map{ $0.real / Double(data.count) }.reversed()
    }
    
    static func restoreSignal(from vc: [Complex<Double>]) -> [Double] {
        return FourierDataFFT(fftData: vc).getRestoredSignal()
    }
    
    static func fft(_ values: inout [Complex<Double>]) {
        if values.count <= 1 {
            return
        }
        
        var even = stride(from: 0, to: values.count, by: 2).map { values[$0] }
        var odd = stride(from: 1, to: values.count, by: 2).map { values[$0] }
        
        fft(&even)
        fft(&odd)
        
        for i in 0..<values.count/2 {
            let r: Complex<Double> = .one
            let theta: Complex<Double> = Complex<Double>(-2.0 * Double.pi * Double(i) / Double(values.count))
            let polar: Complex<Double> = r * .exp(theta * .i)
            let t: Complex<Double> = polar * odd[i]
            
            values[i] = even[i] + t
            values[i + values.count/2] = even[i] - t
        }
    }
}
