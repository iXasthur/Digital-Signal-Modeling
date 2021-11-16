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
        
        if !signal0.isEmpty {
            let start = Date().timeIntervalSince1970
            self.data = CorrelationDataP.corr(signal0, signal1)
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
    
    static func corr(_ v0: Double, _ v1: Double) -> Double {
        return -1
    }
    
    static func corr(_ v0: [Double], _ v1: [Double]) -> [Double] {
        var data: [Double] = []

        let n = v0.count

        /* Calculate the mean of the two series x[], y[] */
        var mx = 0.0;
        var my = 0.0;
        for i in 0..<n {
            mx += v0[i];
            my += v1[i];
        }
        mx /= Double(n);
        my /= Double(n);

        /* Calculate the denominator */
        var sx = 0.0;
        var sy = 0.0;
        for i in 0..<n {
            sx += (v0[i] - mx) * (v0[i] - mx);
            sy += (v1[i] - my) * (v1[i] - my);
        }
        let denom = sqrt(sx * sy);

//        for delay in (-n + 1)..<n {
//            var sxy = 0.0;
//
//            for i in 0..<n {
//                let j = i + delay;
//                if (j < 0 || j >= n) {
//                    continue
//                } else {
//                    sxy += (v0[i] - mx) * (v1[j] - my);
//                }
//            }
//
//            data.append(sxy / denom)
//        }
        
        for delay in ((-n + 1)...0) {
            var sxy = 0.0;

            for q in 0..<n {
                let j = (q + delay) % n;
                let i = q % n;

                let a0: Double
                if i >= 0 {
                    a0 = (v0[i] - mx)
                } else {
                    a0 = (v0[n - 1 + i] - mx)
                }

                let a1: Double
                if j >= 0 {
                    a1 = (v1[j] - my)
                } else {
                    a1 = (v1[n - 1 + j] - my)
                }

                sxy += a0 * a1;
            }

            data.append(sxy / denom)
        }

        return data
    }
}
