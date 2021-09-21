//
//  ChartLineView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

fileprivate struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

fileprivate struct ChartLine: View {
    let data: [Double]
    let frame: CGRect
    
    let padding:CGFloat = 3
    
    func lineChart(points:[Double], step:CGPoint) -> Path {
        var path = Path()
        if (points.count < 2){
            return path
        }
        
        guard let offset = points.min() else { return path }
        let p1 = CGPoint(x: 0, y: CGFloat(points[0]-offset)*step.y)
        path.move(to: p1)
        
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y*CGFloat(points[pointIndex]-offset))
            path.addLine(to: p2)
        }
        
        return path
    }
    
    var stepWidth: CGFloat {
        if data.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.count-1)
    }
    
    var stepHeight: CGFloat {
        var min: Double?
        var max: Double?
        let points = self.data
        
        if let minPoint = points.min(), let maxPoint = points.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
        } else {
            return 0
        }
        
        if let min = min, let max = max, min != max {
            if (min <= 0){
                return (frame.size.height-padding) / CGFloat(max - min)
            } else{
                return (frame.size.height-padding) / CGFloat(max + min)
            }
        }
        
        return 0
    }
    
    var path: Path {
        let points = self.data
        return lineChart(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    var body: some View {
        self.path
            .stroke(Color.green ,style: StrokeStyle(lineWidth: 3, lineJoin: .round))
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .padding(.bottom, padding/2)
            .drawingGroup()
    }
}

struct ChartLineView: View {
    var data: [Double]
    var title: String?
    var height: CGFloat? = 200
    
    public var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
                if (self.title != nil){
                    Text(self.title!)
                        .font(.title)
                }
                HStack {
                    VStack(alignment: .trailing) {
                        Text(String(format: "%.2f", data.max()!))
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f", data.min()!))
                            .font(.headline)
                    }
                    
                    VStack(spacing: 0) {
                        Line()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(Color.secondary.opacity(0.5))
                            .frame(height: 1)
                        GeometryReader{ reader in
                            ChartLine(
                                data: self.data,
                                frame: CGRect(x: 0, y: 0, width: reader.frame(in: .local).width , height: reader.frame(in: .local).height)
                            )
                        }
                        Line()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(Color.secondary.opacity(0.5))
                            .frame(height: 1)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .frame(height: height)
    }
}
