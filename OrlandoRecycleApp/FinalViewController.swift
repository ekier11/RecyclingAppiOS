//
//  FinalViewController.swift
//  OrlandoRecycleApp
//
//  Created by Elizabeth Kiernan on 3/24/21.
//
import UIKit

class FinalViewController: UIViewController {

    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var xMark: UIImageView!
    @IBOutlet weak var recyclableResultLabel: UILabel!
    @IBOutlet weak var zeroWasteMessageLabel: UILabel!
    @IBOutlet weak var productText: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var zeroWasteInfoButton: UIButton!
    let scannerViewController = ScannerViewController()
    public weak var delegate: ScannerViewDelegate?
    
    var text: String = ""
    var recycle: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        scannerViewController.delegate = self
        productText?.text = text
        if (recycle == 0) {
            recyclableResultLabel.text = "Is Recyclable"
        } else {
            recyclableResultLabel.text = "Is NOT Recyclale"
        }
    }
}


extension FinalViewController: ScannerViewDelegate {
    func didFindScannedText(text: String) {
        productText.text = text
        checkMark.isHidden = false
    }
}

extension FinalViewController {
    private func updateUI() {
        recyclableResultLabel.textAlignment = .center
        productText.text = text
        //productText.text = "Hello"
        productText.textAlignment = .center
        productText.textColor = UIColor.black
        productText.font = (UIFont(name: "AppleSDGothicNeo-Bold", size: 25))
        //recyclableImage.isHidden = true
    }
}



