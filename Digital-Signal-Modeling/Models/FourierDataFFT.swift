//
//  FourierDataFFT.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 30.10.2021.
//

import Foundation
import ComplexModule

class FourierDataFFT: FourierData {
    private let fftValues: [Complex<Double>]
    
    init(signalValues: [Double]) {
        var values: [Complex<Double>] = []
        signalValues.forEach { value in
            values.append(Complex<Double>(value))
        }
        
        FourierDataFFT.fft(&values)
        
        fftValues = values
    }
    
    func getAmplitudeSpectrum() -> [Double] {
        var values: [Double] = []
        fftValues.forEach { fftV in
            var value: Double = fftV.length
            value = value * 2 / Double(fftValues.count)
            values.append(value)
        }
        return values
    }
    
    func getPhaseSpectrum() -> [Double] {
        var values: [Double] = []
        fftValues.forEach { fftV in
            let value: Double = -atan2(fftV.imaginary, fftV.real)
            values.append(value)
        }
        return values
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
