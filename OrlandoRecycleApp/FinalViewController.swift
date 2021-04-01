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
    
    var recycleBit: Int = 0   // -1=No Match, 0=not Recyclable, 1=recyclable
    var productName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scannerViewController.delegate = self
        updateUI()
        print("Final View")
    }
}

/*
extension FinalViewController: ScannerViewDelegate {
    func didFindScannedText(text: String) {
        productText.text = productName
        //from db
    }
}
*/


extension FinalViewController {
    private func updateUI() {
        
        //Handle "Recyclable" UILabel text
        if(recycleBit == 0){
            recyclableResultLabel.text = "Not Recyclable"
            recyclableResultLabel.textColor = UIColor.black
        }
        else if(recycleBit == 1){
            recyclableResultLabel.text = "Recyclable!"
            recyclableResultLabel.textColor = UIColor.green
        }
        else if(recycleBit == -1){
            recyclableResultLabel.text = "No Match Found"
            recyclableResultLabel.textColor = UIColor.black
        }
        //Handle Product Name UILabel text
        productText.text = productName
        productText.textAlignment = .center
        productText.textColor = UIColor.black
        productText.font = (UIFont(name: "AppleSDGothicNeo-Bold", size: 25))
        
        //recyclableImage.isHidden = true
        
    }
}



