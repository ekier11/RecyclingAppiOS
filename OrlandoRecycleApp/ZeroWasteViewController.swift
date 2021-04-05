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
    @IBOutlet weak var commercialFoodWasteButton: UIButton!
    @IBOutlet weak var recycleAtHomeButton: UIButton!
    @IBOutlet weak var backyardCompostingButton: UIButton!
    @IBOutlet weak var electronicWasteButton: UIButton!
    @IBOutlet weak var returnCookingOilButton: UIButton!
    @IBOutlet weak var foodWasteDropOffButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        firstTextLabel.text = ("We are finding innovative ways to put your waste to work and find solutions for our continually evolving waste stream, such as employing next-generation waste and recycling technology, increasing commercial and residential recycling participation, developing food waste diversion and composting programs, and creating policies and standards that reduce overall waste generation.")
        
        secondTextLabel.text = ("Orlando continues to strive to become a zero waste community, aiming to eliminate sending solid waste to landfills by 2040.")
        
    }
    
    @IBAction func didTapCommercialFoodWasteButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:"https://www.orlando.gov/Trash-Recycling/Commercial-Food-Waste-Recycling")! as URL, options:
            [:], completionHandler: nil)
    }
    
    @IBAction func didTapRecycleAtHomeButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:"https://www.orlando.gov/Trash-Recycling/What-Goes-Where")! as URL, options:
            [:], completionHandler: nil)
    }
    
    @IBAction func didTapBackyardCompostingButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:"https://www.orlando.gov/Trash-Recycling/Request-a-Free-Composter")! as URL, options:
            [:], completionHandler: nil)
    }
    
    @IBAction func didTapElectronicWasteButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:"https://www.orlando.gov/Our-Government/Departments-Offices/Public-Works/Streets-and-Stormwater-Division/Keep-Orlando-Beautiful/Electronic-Waste-and-Textile-Recycling-Event")! as URL, options:
            [:], completionHandler: nil)
    }
    
    @IBAction func didTapReturnCookingOilButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:"https://www.orlando.gov/Trash-Recycling/Return-Your-Cooking-Oil-Recycling-Container")! as URL, options:
            [:], completionHandler: nil)
    }
    
    @IBAction func didTapFoodWasteDropOffButton(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://www.orlando.gov/Initiatives/Food-Waste-Drop-Off")! as URL, options:
            [:], completionHandler: nil)
    }
    
    
}
