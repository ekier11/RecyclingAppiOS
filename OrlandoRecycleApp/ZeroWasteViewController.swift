//
//  ZeroWasteViewController.swift
//  OrlandoRecycleApp
//
//  Created by Elizabeth Kiernan on 3/23/21.
//

import UIKit

class ZeroWasteViewController: UIViewController {

    @IBOutlet weak var firstTextLabel: UILabel!
    @IBOutlet weak var secondTextLabel: UILabel!
    @IBOutlet weak var commercialFoodWasteLabel: UILabel!
    @IBOutlet weak var commercialFoodWasteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        firstTextLabel.text = ("We are finding innovative ways to put your waste to work and find solutions for our continually evolving waste stream, such as employing next-generation waste and recycling technology, increasing commercial and residential recycling participation, developing food waste diversion and composting programs, and creating policies and standards that reduce overall waste generation.")
        
        secondTextLabel.text = ("Orlando continues to strive to become a zero waste community, aiming to eliminate sending solid waste to landfills by 2040.")
        
        commercialFoodWasteButton.addTarget(self, action: Selector(("didTapCFWButton")), for: .touchUpInside)

        
    }
    
    @IBAction func didTapCFWButton(sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "https://www.orlando.gov/Trash-Recycling/Commercial-Food-Waste-Recycling")!)
    }
    
}
