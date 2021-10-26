//
//  SignalChartEx.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 26.10.2021.
//

import SwiftUI

fileprivate struct SpectreSheetBody: View {
    let signal: Signal
    
    var body: some View {
        VStack {
            SignalChart(signal: signal, title: "Sine Spectre", compact: true)
                .padding(.top, 10)
            SignalChart(signal: signal, title: "Cosine Spectre", compact: true)
                .padding(.top, 10)
            SignalChart(signal: signal, title: "Sine Spectre", compact: true)
                .padding(.top, 10)
            SignalChart(signal: signal, title: "Cosine Spectre", compact: true)
                .padding(.top, 10)
            SignalChart(signal: signal, title: "Sine Spectre", compact: true)
                .padding(.top, 10)
            SignalChart(signal: signal, title: "Cosine Spectre", compact: true)
                .padding(.top, 10)
        }
    }
}

struct SignalChartEx: View {
    let signal: Signal
    let title: String?
    let compact: Bool
    
    private let player: SignalPlayer
    
    @State private var isSpectreSheetShown = false
    
    init(signal: Signal, title: String?, compact: Bool = false) {
        self.signal = signal
        self.title = title
        self.compact = compact
        self.player = SignalPlayer(signal: signal)
    }
    
    var buttons: [HoldableButton] {
        return [
            HoldableButton(
                icon0: "play",
                icon1: "play.fill",
                onTap: {
                    player.play()
                },
                onRelease: {
                    player.stop()
                }),
            HoldableButton(
                icon0: "square.stack.3d.up",
                icon1: "square.stack.3d.up.fill",
                onTap: {
                    
                }, onRelease: {
                    isSpectreSheetShown.toggle()
                }),
            HoldableButton(
                icon0: "square.and.arrow.up",
                icon1: "square.and.arrow.up.fill",
                onTap: {
                    
                },
                onRelease: {
                    player.save()
                })
        ]
    }
    
    var body: some View {
        SignalChart(signal: signal, title: title, compact: compact, buttons: buttons)
            .sheet(isPresented: $isSpectreSheetShown) {
                SheetView(
                    isPresented: $isSpectreSheetShown,
                    title: "Spectre",
                    view: AnyView(SpectreSheetBody(signal: signal)),
                    onCancel: nil,
                    onAccept: {}
                )
            }
    }
}
