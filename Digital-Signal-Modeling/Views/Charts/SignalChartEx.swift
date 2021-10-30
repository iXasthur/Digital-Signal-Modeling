//
//  SignalChartEx.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 26.10.2021.
//

import SwiftUI

fileprivate struct SpectreSheetBody: View {
    private let count = 4096
    
    let signal: FourierSignal
    
    var amplitudeValues: [Double] {
        return []
    }
    
    var phaseValues: [Double] {
        return []
    }
    
    var restoredSignalValues: [Double] {
        return []
    }
    
    var body: some View {
        VStack {
            ChartLineView(values: amplitudeValues, title: "Amplitude Spectre", compact: true)
                .padding(.top, 10)
            
            ChartLineView(values: phaseValues, title: "Phase Spectre", compact: true)
                .padding(.top, 10)
            
            ChartLineView(values: restoredSignalValues, title: "Restored Signal", compact: true)
                .padding(.top, 10)
        }
    }
}

struct SignalChartEx: View {
    let signal: BaseSignal
    let title: String?
    let compact: Bool
    
    private let player: SignalPlayer
    
    @State private var isSpectreSheetShown = false
    
    init(signal: BaseSignal, title: String?, compact: Bool = false) {
        self.signal = signal
        self.title = title
        self.compact = compact
        self.player = SignalPlayer(signal: signal)
    }
    
    var buttons: [HoldableButton] {
        var b: [HoldableButton] = []
        
        b.append(
            HoldableButton(
                icon0: "play",
                icon1: "play.fill",
                onTap: {
                    player.play()
                },
                onRelease: {
                    player.stop()
                })
        )
        
        if signal is FourierSignal {
            b.append(
                HoldableButton(
                    icon0: "square.stack.3d.up",
                    icon1: "square.stack.3d.up.fill",
                    onTap: {
                        
                    }, onRelease: {
                        isSpectreSheetShown.toggle()
                    })
            )
        }
        
        b.append(
            HoldableButton(
                icon0: "square.and.arrow.up",
                icon1: "square.and.arrow.up.fill",
                onTap: {
                    
                },
                onRelease: {
                    player.save()
                })
        )
        
        return b
    }
    
    var body: some View {
        SignalChart(signal: signal, title: title, compact: compact, buttons: buttons)
            .sheet(isPresented: $isSpectreSheetShown) {
                SheetView(
                    isPresented: $isSpectreSheetShown,
                    title: "Spectre",
                    view: AnyView(SpectreSheetBody(signal: signal as! FourierSignal)),
                    onCancel: nil,
                    onAccept: {}
                )
            }
    }
}
