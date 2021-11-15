//
//  CorrelationView.swift
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

struct CorrelationView: View {
    
    @State private var isShowingSheet = false
    
    @State private var signal0: SingleVoiceSignal? = .createSine(amplitude: 1, startPhase: 0, frequency: 1)
    @State private var signal1: SingleVoiceSignal? = nil
    
    @State private var indexToEdit: Int? = nil
    @State private var signalToEdit: SingleVoiceSignal = .createDefault()
    
    var body: some View {
        ScrollView {
            VStack {
                SignalChartExE(signal: $signal0, title: "First", compact: true)
                    .padding(.top, 10)
                SignalChartExE(signal: $signal1, title: "Second", compact: true)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
//        .sheet(isPresented: $isShowingSheet) {
//            SheetView(
//                isPresented: $isShowingSheet,
//                title: signalToEdit == nil ? "Add signal" : "Edit signal",
//                view: AnyView(CreatorSheetBody(editedSignal: $signalToEdit)),
//                onCancel: {},
//                onAccept: {
//                    if indexToEdit != nil {
//                        signal.signals[indexToEdit!] = buffSignal
//                    } else {
//                        signal.signals.append(buffSignal)
//                    }
//                },
//                idealWidth: nil,
//                idealHeight: nil
//            )
//        }
    }
}
