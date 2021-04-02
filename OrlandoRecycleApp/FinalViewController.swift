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
    
    var recycle: Int = 0
    var recycleBit: Int = 0   // -1=No Match, 0=not Recyclable, 1=recyclable
    var productName: String = ""
    var recycleLabelMessage: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
}

extension FinalViewController {
    private func updateUI() {
        //Handle "Recyclable" UILabel text
        if(recycleBit == 0){
            recyclableResultLabel.text = "Not Recyclable"
            recyclableResultLabel.textAlignment = .center
            recyclableResultLabel.textColor = UIColor.red
            xMark.isHidden = false
        }
        else if(recycleBit == 1){
            recyclableResultLabel.text = "Recyclable!"
            recyclableResultLabel.textAlignment = .center
            recyclableResultLabel.textColor = UIColor.systemGreen
            recyclableResultLabel.isHidden = false
            zeroWasteMessageLabel.text = recycleLabelMessage
            checkMark.isHidden = false
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
        
    }
}



