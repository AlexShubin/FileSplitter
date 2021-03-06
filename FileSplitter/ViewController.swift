//
//  Copyright © 2018 Alex Shubin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    private let fileSplitter: FileSplitterType = FileSplitter()
    
    @IBOutlet weak var runButton: NSButton!
    @IBOutlet weak var selectButton: NSButton!
    @IBOutlet weak var activityIndicator: NSProgressIndicator!
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
            showAlert(title: "Error", text: "Choose the file first!")
            return
        }
        setLoadingState(true)
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            let result = self.fileSplitter.split(flieUrl: path, chunksCount: self.chunksCount)
            DispatchQueue.main.async {
                self.setLoadingState(false)
                switch result {
                case .success:
                    self.showAlert(title: "Success", text: "Done!")
                case .failure(let error):
                    switch error {
                    case .readFileError:
                        self.showAlert(title: "Error", text: "Couldn't read file!")
                    case .writeFileError:
                        self.showAlert(title: "Error", text: "Couldn't save file!")
                    }
                }
            }
        }
    }
    
    @IBAction private func chunksStepperDidChange(_ sender: NSStepper) {
        chunksCount = sender.integerValue
    }
    
    @IBAction private func selectButtonTap(_ sender: NSButton) {
        let dialog = NSOpenPanel()
        
        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["txt"]
        
        if dialog.runModal() == .OK {
            filePath = dialog.url
        }
    }
    
    private func setLoadingState(_ isLoading: Bool) {
        runButton.isEnabled = !isLoading
        selectButton.isEnabled = !isLoading
        if isLoading {
            activityIndicator.startAnimation(nil)
        } else {
            activityIndicator.stopAnimation(nil)
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

