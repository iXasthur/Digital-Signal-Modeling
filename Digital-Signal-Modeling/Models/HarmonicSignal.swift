//
//  HarmonicSignal.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 20.09.2021.
//

import Foundation

struct HarmonicSignal {
    var name: String = "Sin"
    
    var formula: (_ count: Int, _ n: Int) -> Double
    
    func getValues(_ count: Int) -> [Double] {
        var values: [Double] = []
        for n in 0...count {
            values.append(formula(count, n))
        }
        return values
    }
    
    static func createDefault() -> HarmonicSignal {
        return HarmonicSignal(
            formula: { (_: Int, n: Int) -> Double in
                return Double(n)
            }
        )
    }
    
    static func createSin(amplitude: Double, startPhase: Double, frequency: Double) -> HarmonicSignal {
        return HarmonicSignal(
            formula: { (count: Int, n: Int) -> Double in
                let t = Double(n) / Double(count)
                return amplitude * sin((2 * Double.pi * frequency * t) + startPhase)
            })
    }
    
    static func createImpulse(amplitude: Double, startPhase: Double, frequency: Double, duty: Double) -> HarmonicSignal {
        return HarmonicSignal(
            formula: { (count: Int, n: Int) -> Double in
                let t = Double(n) / Double(count)
                let phase = (startPhase + 2 * Double.pi * t * frequency).truncatingRemainder(dividingBy: 2 * Double.pi)
                return phase <= duty ? 1.0 : -1.0
            })
    }
    
    static func createTriangle(amplitude: Double, startPhase: Double, frequency: Double) -> HarmonicSignal {
        let period = 1 / frequency
        
        return HarmonicSignal(
            formula: { (count: Int, n: Int) -> Double in
                let t = Double(n) / Double(count)
                let v0 = 2 * amplitude / Double.pi
                let v1 = asin(sin(2 * Double.pi / period * t + startPhase))
                return v0 * v1
            })
    }
    
    static func createSaw(amplitude: Double, startPhase: Double, frequency: Double) -> HarmonicSignal {
        let period = 1 / frequency
        
        return HarmonicSignal(
            formula: { (count: Int, n: Int) -> Double in
                let x = Double(n) / Double(count)
                let v0 = 2 * amplitude / Double.pi
                let v1 = atan(tan(Double.pi * x / period + startPhase/2))
                return v0 * v1
            })
    }
    
    static func createNoise(amplitude: Double) -> HarmonicSignal {
        return HarmonicSignal(
            formula: { (_: Int, _: Int) -> Double in
                return Double.random(in: -amplitude...amplitude)
            })
    }
}
