//
//  DetailsVC.swift
//  JobFinder
//
//  Created by Abdalwhab on 4/7/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import UIKit

class DetailsVC: AbdalwhabVC {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLB: ClassLabelSizeClass!
    @IBOutlet weak var descriptionLB : ClassLabelSizeClass!
    @IBOutlet weak var dateLB: ClassLabelSizeClass!
    @IBOutlet weak var company: UIButton!
    var selectedObject: AnyObject!
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        SetData()
        // Do any additional setup after loading the view.
    }
    func SetData(){
        if let object = AbdalwhabManager.instance.selectedObject as? GithubModel {
            self.titleLB.text = object.title
            self.company.setTitle(object.company, for: .normal)
            self.descriptionLB.text = object.description?.html2String
            self.dateLB.text = object.created_at?.convertDateString()
            self.url = object.url!
            self.imgView.Load(imgURL: object.company_logo!)
        }else if let object = AbdalwhabManager.instance.selectedObject as? GovModel {
            self.titleLB.text = object.position_title
            self.company.setTitle(object.organization_name, for: .normal)
            self.descriptionLB.text = ""
            self.dateLB.text = object.start_date
            self.url = object.url!
            self.imgView.image = UIImage(named: "Default")
        }
    }
    @IBAction func OpenURL(_ sender: Any) {
        let url = URL(string: self.url)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}
