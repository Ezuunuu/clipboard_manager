//
//  ClipboardItem.swift
//  ClipboardManager
//
//  Created by 이준우 on 3/1/25.
//

import Foundation

struct ClipboardItem: Identifiable {
    let id = UUID() // 고유 id
    let content: String // 저장한 정보
    let timestamp: Date // 저장한 시간
}
