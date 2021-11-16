//
//  SignalChartExE.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 15.11.2021.
//

import SwiftUI

fileprivate struct CreatorSheetBody: View {
    @Binding var editedSignal: SingleVoiceSignal

    var body: some View {
        VStack {
            SingleVoiceSignalCreator(signal: $editedSignal)
                .padding(.top, 10)
            SignalChartEx(signal: editedSignal, title: nil)
                .padding(.top, 10)
        }
    }
}

struct SignalChartExE: View {
    @Binding var signal: SingleVoiceSignal?
    
    var count: Int = 4096
    var title: String? = nil
    var compact: Bool = false
    var hideLabels: Bool = false
    
    @State private var isShowingSheet = false
    @State private var buffSignal: SingleVoiceSignal = .createDefault()
    
    var editButtons: [HoldableButton] {
        return [
            HoldableButton(
                icon0: "pencil",
                icon1: "pencil",
                onTap: {},
                onRelease: {
                    buffSignal = signal!
                    isShowingSheet.toggle()
                }
            ),
            HoldableButton(
                icon0: "minus",
                icon1: "minus",
                color: .red,
                onTap: {},
                onRelease: {
                    signal = nil
                }
            )
        ]
    }
    
    var createButtons: [HoldableButton] {
        return [
            HoldableButton(
                icon0: "plus",
                icon1: "plus",
                onTap: {},
                onRelease: {
                    buffSignal = .createDefault()
                    isShowingSheet.toggle()
                }
            )
        ]
    }
    
    var body: some View {
        VStack {
            if signal != nil {
                SignalChartEx(signal: signal!, title: title, compact: compact, hideLabels: hideLabels, additionalButtons: [editButtons], disableSound: false, count: count)
            } else {
                SignalChart(signal: EmptySignal(), title: title, compact: compact, hideLabels: hideLabels, buttons: [createButtons], count: count)
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            SheetView(
                isPresented: $isShowingSheet,
                title: signal == nil ? "Add signal" : "Edit signal",
                view: AnyView(CreatorSheetBody(editedSignal: $buffSignal)),
                onCancel: {},
                onAccept: {
                    signal = buffSignal
                },
                idealWidth: nil,
                idealHeight: nil
            )
        }
    }
}
