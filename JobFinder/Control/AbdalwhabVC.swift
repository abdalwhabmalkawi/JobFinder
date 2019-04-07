//
//  AbdalwhabVC.swift
//  JobFinder
//
//  Created by Abdalwhab on 4/6/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import UIKit
import SwiftMessages
import Alamofire
class AbdalwhabVC: UIViewController,UIGestureRecognizerDelegate,UISearchBarDelegate {
    
    
    let imgNoData = UIImageView()
    var refresh : UIRefreshControl!
    var profileImg: UIBarButtonItem!
    
    var requireResreshView = false
    var haveNavController = true
    var requireSearchBar = false
    let search = UISearchController(searchResultsController: nil)
    let images = UIImageView()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Localize()
        setNeedsStatusBarAppearanceUpdate()
        if haveNavController {
            navigationController!.navigationBar.barStyle = .blackOpaque;
        }
        if requireResreshView {
            self.refresh = UIRefreshControl()
            self.refresh.addTarget(self, action: #selector(ReloadData(sender:)), for: .valueChanged)
            self.refresh.tintColor = UIColor.gray
        }
        if requireSearchBar {
            search.searchBar.delegate = self

            search.hidesNavigationBarDuringPresentation = false
            search.searchBar.searchBarStyle = .minimal
            navigationItem.searchController = search
            
            definesPresentationContext = true
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadData()
    }
    func Localize(){
        
    }
    func LoadData(){
        imgNoData.removeFromSuperview()
        AbdalwhabManager.instance.startNetworkMonitoring()
    }
    @objc func ReloadData(sender: UIButton){
        LoadData()
    }
    func SetNoData(){
        self.imgNoData.image = UIImage(named: "noData")
        self.imgNoData.contentMode = .scaleAspectFit
        self.imgNoData.frame = CGRect(x: view.bounds.width/2-100, y: view.bounds.height/2-100, width: 200, height: 200)
        self.view.addSubview(self.imgNoData)
    }
    
    func ShowNotifyType1(message: String,theme: Theme){
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(theme)
        view.configureContent(body: message)
        SwiftMessages.show(view: view)
    }
}
