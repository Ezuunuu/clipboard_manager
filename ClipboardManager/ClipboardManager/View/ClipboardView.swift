//
//  ClipboardView.swift
//  ClipboardManager
//
//  Created by 이준우 on 3/1/25.
//

import SwiftUI

struct ClipboardView: View {
    @StateObject private var viewModel = ClipboardViewModel()
    @State private var showCopyAlert: Bool = false
    @State private var copiedText: String = ""

    var body: some View {
        VStack {
            HStack {
                Text("📋 클립보드 관리")
                    .font(.title)
                    .padding()
                
                Spacer()

                Button(action: {
                    viewModel.clearClipboard()
                }) {
                    Text("Clear Clipboard")
                        .padding(8)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }

            List {
                ForEach(viewModel.clipboardItems) { item in
                    VStack(alignment: .leading) {
                        Text(item.content)
                            .font(.body)
                            .foregroundColor(.primary)
                        Text("\(item.timestamp, formatter: dateFormatter)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(4)
                    .onTapGesture(count: 2) {
                        viewModel.copyToClipboard(content: item.content)
                        copiedText = item.content
                        showCopyAlert = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showCopyAlert = false
                        }
                    }
                }
            }
        }
        .frame(minWidth: 300, minHeight: 400)
        .overlay(
            // ✅ 복사 알림 표시
            VStack {
                if showCopyAlert {
                    Text("Copied: \(copiedText)")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3))
                }
            }
            .padding(.bottom, 50),
            alignment: .bottom
        )
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()
