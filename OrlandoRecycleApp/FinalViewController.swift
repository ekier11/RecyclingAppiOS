//
//  FinalViewController.swift
//  OrlandoRecycleApp
//
//  Created by Elizabeth Kiernan on 3/24/21.
//
import UIKit



class FinalViewController: UIViewController, ScannerViewDelegate {
    
    func didFindScannedText(text: String) {

    }

    //Interface Elements
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var xMark: UILabel!
    @IBOutlet weak var questionMark: UIImageView!
    @IBOutlet weak var recyclableResultLabel: UILabel!
    @IBOutlet weak var zeroWasteMessageLabel: UILabel!
    @IBOutlet weak var productText: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var zeroWasteInfoButton: UIButton!
    
    //Delegates
    let scannerViewController = ScannerViewController()
    public weak var delegate: ScannerViewDelegate?
    
    //Variables
    var text: String = "" // Product Name
    var recycle: Int = 0  // Product Bit | -1=No Match, 0=not Recyclable, 1=recyclable
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productText.font = (UIFont(name: "AppleSDGothicNeo-Bold", size: 25))
        
        //scannerViewController.delegate = self
        
        //Set RecyclableResultLabel, productText, and unhide corresponding image
        if (recycle == 0) {
            recyclableResultLabel.text = "Is NOT Recyclable"
            recyclableResultLabel.textColor = UIColor.black
            productText.text = text
            xMark.isHidden = false
        }
        else if(recycle == 1){
            recyclableResultLabel.text = "Is Recyclable"
            recyclableResultLabel.textColor = UIColor(red: (154/255.0), green: (199/255.0), blue: (82/255.0), alpha: 1.0)
            productText.text = text
            checkMark.isHidden = false
        }
        else {
            recyclableResultLabel.text = "No Match"
            recyclableResultLabel.textColor = UIColor.black
            productText.text = "Please try again!"
            questionMark.isHidden = false
        }
        
        //Set zeroWasteMessageLabel
        if((text.range(of: "Kraft Mac N' Cheese Original") ) != nil){
            zeroWasteMessageLabel.text = "The box is recyclable, but the cheese pouch is not. Please make sure to throw away the cheese pouch after use."
        }
        else if((text.range(of: "Skippy Creamy Peanut Butter") ) != nil){
            zeroWasteMessageLabel.text = "Please make sure to clean out your jar before recycling."
        }
        else if((text.range(of: "Great Value Purified Drinking Water") ) != nil){
            zeroWasteMessageLabel.text = "To live a more zero waste lifestyle, try using a reusable water bottle."
        }
        else{
            zeroWasteMessageLabel.text = ""
        }
    }
}


/*
extension FinalViewController: ScannerViewDelegate {
    func didFindScannedText(text: String) {
        productText.text = text
        checkMark.isHidden = false
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
*/

