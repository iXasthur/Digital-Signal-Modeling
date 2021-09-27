//
//  SignalChart.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 20.09.2021.
//

import SwiftUI

struct SignalChart: View {
    
    private let count = 4096
    
    let signal: Signal
    let title: String?
    let compact: Bool
    
    private let player: SignalPlayer
    private let buttons: [HoldableButton]
    
    init(signal: Signal, title: String?, compact: Bool = false) {
        self.signal = signal
        self.title = title
        self.compact = compact
        
        let player = SignalPlayer(signal: signal)
        
        self.player = player
        
        self.buttons = [
            HoldableButton(
                icon0: "play",
                icon1: "play.fill",
                onTap: {
                    player.play()
                }, onRelease: {
                    player.stop()
                }),
            HoldableButton(
                icon0: "square.and.arrow.up",
                icon1: "square.and.arrow.up.fill",
                onTap: {
                    
                }, onRelease: {
                    player.save()
                })
        ]
    }
    
    var body: some View {
        ChartLineView(
            data: signal.getValues(count),
            title: title,
            height: compact ? 140 : 200,
            actions: buttons
        )
    }
}
