//
//  ClipboardViewController.swift
//  ClipboardManager
//
//  Created by 이준우 on 3/1/25.
//

import Cocoa
import RxSwift
import RxCocoa

class ClipboardViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var clearButton: NSButton!
    
    private let viewModel = ClipboardViewModel()
    private let disposeBag = DisposeBag()
    private var clipboardItems: [ClipboardItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        tableView.delegate = self
        tableView.dataSource = self
        
        clearButton.target = self
        clearButton.action = #selector(clearClipboard)
    }
    
    private func bindViewModel() {
        viewModel.clipboardItemsObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
                self?.clipboardItems = items
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func clearClipboard() {
        viewModel.clearClipboard()
    }
}

extension ClipboardViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return clipboardItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("ClipboardCell"), owner: self) as? NSTableCellView else {
            return nil
        }
        cell.textField?.stringValue = clipboardItems[row].content
        return cell
    }

    func tableView(_ tableView: NSTableView, didClickRow row: Int) {
        let content = clipboardItems[row].content
        viewModel.copyToClipboard(content: content)
    }
}
