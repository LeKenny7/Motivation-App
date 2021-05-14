//
//  DetailEditViewController.swift
//  MotivationProject
//
//  Created by kvle2 on 11/23/19.
//  Copyright © 2019 kvle2. All rights reserved.
//

import UIKit
import CoreData

class DetailEditViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var selectedGoal:String?
    var selectedDetail:String?
    var selectedImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = selectedGoal
        detailLabel.text = selectedDetail
        image.image = selectedImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
