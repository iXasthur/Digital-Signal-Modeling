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
                return amplitude * sin((2 * Double.pi * frequency * Double(n))/Double(count) + startPhase)
            })
    }
    
    static func createImpulse(amplitude: Double, frequency: Double, duty: Double) -> HarmonicSignal {
        let period = 1 / frequency
        
        let h: (Double) -> Double = { x in
            return x > 0 ? 1 : 0
        }
        
        return HarmonicSignal(
            formula: { (count: Int, n: Int) -> Double in
                let x = Double(n) / Double(count)

                var s: Double = 0
                for n in stride(from: -50, to: 50, by: 1) {
                    s = s + (h((x / period) - Double(n)) - h((x / period) - Double(n) - (1 / duty)))
                }
                
                return 2 * amplitude * s - 1
            })
    }
    
    static func createTriangle(amplitude: Double, frequency: Double) -> HarmonicSignal {
        let period = 1 / frequency
        
        return HarmonicSignal(
            formula: { (count: Int, n: Int) -> Double in
                let x = Double(n) / Double(count)
                let v0 = 2 * amplitude / Double.pi
                let v1 = asin(sin(2 * Double.pi / period * x))
                return v0 * v1
            })
    }
    
    static func createSaw(amplitude: Double, frequency: Double) -> HarmonicSignal {
        let period = 1 / frequency
        
        return HarmonicSignal(
            formula: { (count: Int, n: Int) -> Double in
                let x = Double(n) / Double(count)
                let v0 = 2 * amplitude / Double.pi
                let v1 = atan(tan(Double.pi * x / period))
                return v0 * v1
            })
    }
}
