//
//  ViewController.swift
//  ClickableLabelLink
//
//  Created by Ikmal Azman on 14/03/2022.
// https://www.hackingwithswift.com/example-code/strings/how-to-detect-a-url-in-a-string-using-nsdatadetector

import UIKit
import SafariServices

final class ViewController: UIViewController {
    
    // @IBOutlet weak var contentLabel: LabelLink!
    @IBOutlet weak var contentLabel: UILabel!
    
    var detectUrl : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentLabel.isUserInteractionEnabled = true
        detectUrl = contentLabel.text?.detectUrlIn()
//        detectUrl = detectUrlIn(string: contentLabel.text!)
        print("detected : \(detectUrl)")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        contentLabel.addGestureRecognizer(tap)
        
    }
    
    @objc func tap(_ gesture : UITapGestureRecognizer) {
        print("Tap")
        guard let detectUrl = detectUrl, let url = URL(string: detectUrl) else {
            return
        }
        
        openSafari(url)

    }
    
}

extension UIViewController {

    func openSafari(_ url : URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}


extension String {
    /// Allow to determine if string have url and return the url string value
    func detectUrlIn()-> String? {
        let detecter = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detecter.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: self) else {continue}
            let url = self[range]
            print(url)
            return String(url)
        }
        return nil
    }
}
