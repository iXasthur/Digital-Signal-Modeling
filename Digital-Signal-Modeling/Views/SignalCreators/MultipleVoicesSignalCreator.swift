//
//  MultipleVoicesSignalCreator.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 21.09.2021.
//

import SwiftUI

fileprivate struct SheetView: View {
    
    @Binding var isPresented: Bool
    @Binding var signal: MultipleVoicesSignal
    
    let indexToEdit: Int?
    
    @State private var harmonicSignal: SingleVoiceSignal
    
    init(isPresented: Binding<Bool>, signal: Binding<MultipleVoicesSignal>, indexToEdit: Int?) {
        self._isPresented = isPresented
        self._signal = signal
        self.indexToEdit = indexToEdit
        
        if indexToEdit != nil {
            harmonicSignal = _signal.wrappedValue.signals[indexToEdit!]
        } else {
            harmonicSignal = .createDefault()
        }
    }

    var body: some View {
        VStack {
            HStack {
                Button {
                    isPresented.toggle()
                    NSApp.mainWindow?.endSheet(NSApp.keyWindow!)
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(width: 20, height: 20, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
                
                Text(indexToEdit == nil ? "Add signal" : "Edit signal")
                    .font(.headline)
                
                Spacer()
               
                Button {
                    if indexToEdit != nil {
                        signal.signals[indexToEdit!] = harmonicSignal
                    } else {
                        signal.signals.append(harmonicSignal)
                    }
                    
                    isPresented.toggle()
                    NSApp.mainWindow?.endSheet(NSApp.keyWindow!)
                } label: {
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .frame(width: 20, height: 20, alignment: .trailing)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Divider()
            
            SingleVoiceSignalCreator(signal: $harmonicSignal)
                .padding(.top, 10)
            
            SignalChart(signal: harmonicSignal, title: nil)
                .padding(.top, 10)
            
        }
        .padding()
        .frame(minWidth: 500)
    }
}

struct MultipleVoicesSignalCreator: View {
    
    @State private var showingSheet = false
    
    @State private var indexToEdit: Int? = nil
    
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
                        showingSheet.toggle()
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
                showingSheet.toggle()
            } label: {
                Text("Add signal")
            }
            .padding(.top, 10)
        }
        .sheet(isPresented: $showingSheet) {
            SheetView(isPresented: $showingSheet, signal: $signal, indexToEdit: indexToEdit)
        }
    }
}
