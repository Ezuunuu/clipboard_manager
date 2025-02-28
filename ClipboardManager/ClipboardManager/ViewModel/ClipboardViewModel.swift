//
//  ClipboardViewModel.swift
//  ClipboardManager
//
//  Created by 이준우 on 3/1/25.
//

import Foundation
import RxSwift
import RxCocoa

class ClipboardViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    
    @Published var clipboardItems: [ClipboardItem] = []
    
    private let clipboardSubject = BehaviorSubject<[ClipboardItem]>(value: [])
    
    var clipboardItemsObservable: Observable<[ClipboardItem]> {
        return clipboardSubject.asObservable()
    }
    
    init() {
        observeClipboard()
    }
    
    private func observeClipboard() {
        Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let newContent = ClipboardManager.getClipboardContent() {
                    self.addClipboardItem(content: newContent)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func addClipboardItem(content: String) {
        var currentItems = (try? clipboardSubject.value()) ?? []
        
        if !currentItems.contains(where: { $0.content == content }) {
            let newItem = ClipboardItem(content: content, timestamp: Date())
            currentItems.insert(newItem, at: 0)
            clipboardSubject.onNext(currentItems)
            DispatchQueue.main.async {
                self.clipboardItems = currentItems
            }
        }
    }
    
    func clearClipboard() {
        clipboardSubject.onNext([])
        DispatchQueue.main.async {
            self.clipboardItems = []
        }
    }
    
    func copyToClipboard(content: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
    }
}

