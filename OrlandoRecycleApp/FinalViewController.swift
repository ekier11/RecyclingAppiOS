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
    var zeroWasteMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productText.font = (UIFont(name: "AppleSDGothicNeo-Bold", size: 25))
        updateUI()
    }
}

extension FinalViewController {
    private func updateUI() {
        
        print("DATAWORLD: ******** bit: \(recycle)")
        //Handle "Recyclable" UILabel text
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
            zeroWasteMessageLabel.text = zeroWasteMessage
            checkMark.isHidden = false
        }
        else {
            recyclableResultLabel.text = "No Match"
            recyclableResultLabel.textColor = UIColor.black
            productText.text = "Please try again!"
            questionMark.isHidden = false
        }
    }
}

