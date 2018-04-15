//
//  Copyright © 2018 Alex Shubin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var doneLabel: NSTextField!
    @IBOutlet weak var fileNameTextField: NSTextField!
    @IBOutlet weak var chunksCountTextField: NSTextField!
    
    private var chunksCount = 2 {
        didSet {
            chunksCountTextField.stringValue = String(chunksCount)
            doneLabel.isHidden = true
        }
    }
    private var filePath: URL? {
        didSet {
            fileNameTextField.stringValue = filePath?.path ?? ""
            doneLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneLabel.isHidden = true
    }
    
    @IBAction func runButtonTap(_ sender: NSButton) {
        doneLabel.isHidden = true
        guard let path = filePath else {
            fatalError("Should choose file")
        }
        guard let fileData = try? String(contentsOfFile: path.path, encoding: .utf8) else {
            fatalError("Couldn't read file")
        }
        let fileStrings = fileData.components(separatedBy: .newlines).filter { !$0.isEmpty }
        let stringsToWrite = fileStrings.chunked(by: chunksCount).map {
            $0.joined(separator: "\n")
        }
        let dirPath = path.deletingLastPathComponent()
        let fileName = path.deletingPathExtension().lastPathComponent
        let fileExt = path.pathExtension
        for (i, str) in stringsToWrite.enumerated() {
            let newFile = dirPath
                .appendingPathComponent("\(fileName)_\(i+1)")
                .appendingPathExtension(fileExt)
            try! str.write(to: newFile, atomically: true, encoding: .utf8)
        }
        doneLabel.isHidden = false
    }
    
    @IBAction func chunksStepperDidChange(_ sender: NSStepper) {
        chunksCount = sender.integerValue
    }
    
    @IBAction func selectButtonTap(_ sender: NSButton) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .txt file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["txt"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            filePath = dialog.url
        } else {
            return
        }
    }
    
}

