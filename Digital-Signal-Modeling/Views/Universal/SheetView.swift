//
//  SheetView.swift
//  Digital-Signal-Modeling
//
//  Created by Михаил Ковалевский on 26.10.2021.
//

import SwiftUI

struct SheetView: View {
    @Binding var isPresented: Bool
    
    let title: String
    let view: AnyView
    let onCancel: (() -> Void)?
    let onAccept: (() -> Void)?

    var body: some View {
        VStack {
            HStack {
                Button {
                    onCancel?()
                    
                    isPresented.toggle()
                    NSApp.mainWindow?.endSheet(NSApp.keyWindow!)
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(width: 20, height: 20, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .opacity(onCancel == nil ? 0 : 1)
                .buttonStyle(PlainButtonStyle())

                Spacer()
                
                Text(title)
                    .font(.headline)
                
                Spacer()
               
                Button {
                    onAccept?()
                    
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
            
            ScrollView {
                view
            }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 200, maxHeight: 500)
    }
}
