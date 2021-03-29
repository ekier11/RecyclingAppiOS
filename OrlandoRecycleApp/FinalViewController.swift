//
//  FinalViewController.swift
//  OrlandoRecycleApp
//
//  Created by Elizabeth Kiernan on 3/24/21.
//
import UIKit

class FinalViewController: UIViewController {
    @IBOutlet weak var recyclableResultLabel: UILabel!
    @IBOutlet weak var zeroWasteMessageLabel: UILabel!
    @IBOutlet weak var productText: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var zeroWasteInfoButton: UIButton!
    let scannerViewController = ScannerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
        scannerViewController.delegate = self

    }
}


extension FinalViewController {
    private func updateUI() {
        
        //recyclableResultLabel.text = "No barcode scanned"
        recyclableResultLabel.textAlignment = .center
        recyclableResultLabel.textColor = UIColor.white
        recyclableResultLabel.font = (UIFont(name: "AppleSDGothicNeo-Bold", size: 25))
        //recyclableImage.isHidden = true
    }
}


extension FinalViewController: ScannerViewDelegate {
    func didFindScannedText(text: String) {
        productText.text = text
        //from db
        //ImageView?.isHidden = false
        //LabelView?.isHidden = false
    }
}
