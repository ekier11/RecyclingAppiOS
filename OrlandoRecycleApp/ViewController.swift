//
//  ViewController.swift
//  OrlandoRecycleApp
//
//  Created by Elizabeth Kiernan on 3/22/21.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    @IBOutlet weak var zeroWasteLabel: UILabel!
    @IBOutlet weak var upcScanButton: UIButton!
    @IBOutlet weak var productScanButton: UIButton!
    @IBOutlet weak var zeroWasteButton: UIButton!
    @IBOutlet weak var searchBarButton: UIButton!
    
    let scannerViewController = ScannerViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //scannerViewController.delegate = self


        
        zeroWasteLabel.text = ("Orlando continues to strive to become a zero waste community aiming to eliminate sending solid waste to landfills by 2040. Everything that we throw away has potential value. It takes energy, water, and natural resources to make these products. Finding ways to reduce, reuse, and recycle these materials makes a positive impact of the environment and helps to save money.")
    }
    
    
    


    @objc func upcButtonPressed(_ sender: Any) {
        self.navigationController?.pushViewController(scannerViewController, animated: true)
        print("UPC scan button pressed. Will go to final screen")
    }
    
    @IBAction func productButtonPressed(_ sender: Any) {
        print("Product scan button pressed. Will go to final screen")
    }
    
    @IBAction func zeroWasteButtonPressed(_ sender: Any) {
        print("Zero Waste button pressed")
    }
    
    @IBAction func searchBarButtonPressed(_ sender: Any) {
        print("Search bar button pressed")
    }
    
    @objc func scanBarTapped() {
        self.navigationController?.pushViewController(scannerViewController, animated: true)
    }
}
    


