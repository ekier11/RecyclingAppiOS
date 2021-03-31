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
    public weak var delegate: ScannerViewDelegate?
    
    override func viewDidLoad() {
        scannerViewController.delegate = self
        updateUI()
        super.viewDidLoad()
        print("Final View")
        // Do any additional setup after loading the view.
        //updateUI()
            //from db
    }
}


extension FinalViewController: ScannerViewDelegate {
    func didFindScannedText(text: String) {
        print("kraft")
        productText.text = text
        //from db
    }
}


extension FinalViewController {
    private func updateUI() {
        //productText.text = "Hello"
        productText.textAlignment = .center
        productText.textColor = UIColor.white
        productText.font = (UIFont(name: "AppleSDGothicNeo-Bold", size: 25))
        //recyclableImage.isHidden = true
    }
}



