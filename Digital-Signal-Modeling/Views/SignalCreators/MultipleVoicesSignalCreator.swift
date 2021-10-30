//
//  MultipleVoicesSignalCreator.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
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

struct MultipleVoicesSignalCreator: View {
    
    @State private var isShowingSheet = false
    
    @State private var indexToEdit: Int? = nil
    @State private var buffSignal: SingleVoiceSignal = .createDefault()
    
    @Binding var signal: MultipleVoicesSignal
    
    var body: some View {
        VStack {
            ForEach((0..<signal.signals.count), id: \.self) {
                let i = $0
                let s = signal.signals[i]
                
                HStack {
                    Text("\(s.name)")
                    
                    Spacer()
                    
                    Button {
                        indexToEdit = i
                        buffSignal = signal.signals[i]
                        
                        isShowingSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .frame(width: 20, height: 20, alignment: .trailing)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        signal.signals.remove(at: i)
                    } label: {
                        Image(systemName: "minus")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(width: 20, height: 20, alignment: .trailing)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            Button {
                indexToEdit = nil
                buffSignal = .createDefault()
                
                isShowingSheet.toggle()
            } label: {
                Text("Add signal")
            }
            .padding(.top, 10)
        }
        .sheet(isPresented: $isShowingSheet) {
            SheetView(
                isPresented: $isShowingSheet,
                title: indexToEdit == nil ? "Add signal" : "Edit signal",
                view: AnyView(CreatorSheetBody(editedSignal: $buffSignal)),
                onCancel: {},
                onAccept: {
                    if indexToEdit != nil {
                        signal.signals[indexToEdit!] = buffSignal
                    } else {
                        signal.signals.append(buffSignal)
                    }
                },
                idealWidth: nil,
                idealHeight: nil
            )
        }
    }
}
