//
//  Copyright © 2018 Alex Shubin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet private weak var fileNameTextField: NSTextField!
    @IBOutlet private weak var chunksCountTextField: NSTextField!
    
    private var chunksCount = 2 {
        didSet {
            chunksCountTextField.stringValue = String(chunksCount)
        }
    }
    private var filePath: URL? {
        didSet {
            fileNameTextField.stringValue = filePath?.path ?? ""
        }
    }
    
    @IBAction private func runButtonTap(_ sender: NSButton) {
        guard let path = filePath else {
            showAlert(title: "Error", text: "File not chosen!")
            return
        }
        guard let fileData = try? String(contentsOfFile: path.path, encoding: .utf8) else {
            showAlert(title: "Error", text: "Couldn't read file!")
            return
        }
        let fileStrings = fileData.components(separatedBy: .newlines).filter { !$0.isEmpty }
        let stringsToWrite = fileStrings.splitted(chunksCount: chunksCount).map {
            $0.joined(separator: "\n")
        }
        let dirPath = path.deletingLastPathComponent()
        let fileName = path.deletingPathExtension().lastPathComponent
        let fileExt = path.pathExtension
        for (i, str) in stringsToWrite.enumerated() {
            let newFile = dirPath
                .appendingPathComponent("\(fileName)_\(i+1)")
                .appendingPathExtension(fileExt)
            do {
                try str.write(to: newFile, atomically: true, encoding: .utf8)
            } catch {
                showAlert(title: "Error", text: "Couldn't save file!")
                return
            }
        }
        showAlert(title: "Success", text: "Done!")
    }
    
    @IBAction private func chunksStepperDidChange(_ sender: NSStepper) {
        chunksCount = sender.integerValue
    }
    
    @IBAction private func selectButtonTap(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["txt"]
        
        if dialog.runModal() == .OK {
            filePath = dialog.url
        }
    }
    
    private func showAlert(title: String, text: String) {
        guard let window = view.window else {
            return
        }
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.window.level = .modalPanel
        alert.beginSheetModal(for: window)
    }
}

