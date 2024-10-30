//
//  ContentView.swift
//  Grammar Genius
//
//  Created by Naufal Fawwaz Andriawan on 22/10/24.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var grammarChecker = GrammarChecker.shared
    @State private var showEmptyTextDialog: Bool = false
    @State private var showCopiedDialog: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        Picker(
                            Strings.labelGrammarOptions,
                            selection: $grammarChecker.selectedIndex
                        ) {
                            Text(Strings.labelCheck).tag(0)
                            Text(Strings.labelFix).tag(1)
                        }
                        .pickerStyle(.segmented)
                        
                        Text(Strings.labelInput)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .font(.headline)
                            .padding(.top)
                        
                        VStack {
                            TextField(Strings.hintInput, text: $grammarChecker.text, axis: .vertical)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .textSelection(.enabled)
                                .multilineTextAlignment(.leading)
                                .frame(
                                    minHeight: 100,
                                    alignment: .topLeading
                                )
                                .onChange(of: grammarChecker.text) { oldValue, newValue in
                                    if (newValue.count > 100) {
                                        grammarChecker.text = oldValue
                                    }
                                }
                            
                            Divider()
                            
                            Text("\(grammarChecker.text.count) / 100")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .trailing
                                )
                                .foregroundStyle(
                                    grammarChecker.text.count == 100 ? .red : .primary
                                )
                                .padding(.top, 8)
                        }
                        .frame(minWidth: 200, maxWidth: .infinity)
                        .padding()
                        .background(
                            colorScheme == .dark ? Color(rgb: 0xFF373A40) : Color(rgb: 0xFFEEEEEF)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        if grammarChecker.isLoading {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                Text("Generating result...")
                            }
                            .padding(.top, 24)
                        }
                        
                        if grammarChecker.result != nil {
                            Text(Strings.labelResult)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.semibold)
                                .font(.headline)
                                .padding(.top)
                            
                            VStack {
                                Text(grammarChecker.result ?? "")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(minHeight: 100, alignment: .topLeading)
                                
                                if grammarChecker.selectedIndex == 1 {
                                    Divider()
                                    
                                    HStack {
                                        Spacer()
                                        Button {
                                            UIPasteboard.general.string = clearMarkdown(on: grammarChecker.result?.toString() ?? "")
                                            showCopiedDialog = true
                                        } label: {
                                            Image(systemName: "document.on.document")
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .alert(isPresented: $showCopiedDialog) {
                                            Alert(
                                                title: Text("Text Copied!"),
                                                dismissButton: .default(Text("Ok"))
                                            )
                                        }
                                    }
                                    .padding(.top, 8)
                                }
                            }
                            .frame(minWidth: 200, maxWidth: .infinity)
                            .padding()
                            .background(
                                colorScheme == .dark ? .clear : Color(rgb: 0xFFEEEEEF)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    if grammarChecker.text.isEmpty {
                        showEmptyTextDialog = true
                    } else {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                        
                        Task {
                            grammarChecker.result = nil
                            await grammarChecker.checkAndFix()
                        }
                    }
                } label: {
                    Text("Submit")
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 35)
                }
                .buttonStyle(.borderedProminent)
                .alert(isPresented: $showEmptyTextDialog) {
                    Alert(
                        title: Text("Empty Text"),
                        message: Text("Please enter some text to check."),
                        dismissButton: .default(Text("Ok"))
                    )
                }
            }
            .padding()
            .navigationTitle(Bundle.applicationName)
            .navigationBarTitleDisplayMode(.large)
            .onOpenURL { url in
                if url.scheme == "grammar-check" {
                     print("Opened from deeplink")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
