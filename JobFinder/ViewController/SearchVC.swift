//
//  SearchVC.swift
//  JobFinder
//
//  Created by abdalwhab on 4/6/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchVC: AbdalwhabVC {
    @IBOutlet weak var table: UITableView!
    
    var searchQuery: String = ""
    var endPoint: EndPint!
    var arrData: [AnyObject] = []
    override func viewDidLoad() {
        super.requireSearchBar = true
        super.requireResreshView = true
        super.viewDidLoad()
        self.table.addSubview(refresh)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.separatorStyle = .none
    }
    override func LoadData() {
        super.LoadData()
        EndPint.bURL = AbdalwhabManager.instance.selectedBaseURL
        switch AbdalwhabManager.instance.selectedBaseURL {
            
        case AbdalwhabManager.instance.baseURL[0]:
            var param = ["search":searchQuery]
            if AbdalwhabManager.instance.fillerByLonLat {
                param = ["search":searchQuery,"lat":AbdalwhabManager.instance.lat,"long":
                AbdalwhabManager.instance.long]
            }
            endPoint = EndPint.githubPosition(param: param)
            GetDataGitHub()
            
        case AbdalwhabManager.instance.baseURL[1]:
            var param = ["query":searchQuery]
            if AbdalwhabManager.instance.fillerByLonLat {
                param = ["query":searchQuery,"lat_lon":"\(AbdalwhabManager.instance.lat),\(AbdalwhabManager.instance.long)"]
            }
            endPoint = EndPint.govSearch(param: param)
            GetDataJob()
            
        default:
            break
        }
        
        
    }
    // to call github api
    func GetDataGitHub(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        API.sharedInstance.Request(endPoint: self.endPoint) { (response: Response<[GithubModel]>) in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            self.refresh.endRefreshing()
            switch response.result {
                
            case .success(let val):
                self.arrData = val
                self.table.reloadData()
            case .failure(let error):
                self.ShowNotifyType1(message: error.localizedDescription, theme: .error)
            }
        }
    }
    // to call gov search api
    func GetDataJob(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        API.sharedInstance.Request(endPoint: self.endPoint) { (response: Response<[GovModel]>) in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            self.refresh.endRefreshing()
            switch response.result {
            case .success(let val):
                self.arrData = val
                self.table.reloadData()
            case .failure(let error):
                self.ShowNotifyType1(message: error.localizedDescription, theme: .error)
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchQuery = searchBar.text!
        LoadData()
    }
}
extension SearchVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height/3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MainSearchCell.Cell(for: table, at: indexPath)
        let data = arrData[indexPath.row]
        cell.imgView.image = nil
        if let object = data as? GithubModel {
            cell.imgView.Load(imgURL: object.company_logo ?? "")
            cell.titleLB.text = object.title
        }else if let object = data as? GovModel {
            cell.imgView.image = UIImage(named: "Default")
            cell.titleLB.text = object.position_title
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AbdalwhabManager.instance.selectedObject = arrData[indexPath.row]
        self.performSegue(withIdentifier: "DetailsVC", sender: nil)
    }
}
