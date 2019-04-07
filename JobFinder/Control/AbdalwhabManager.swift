//
//  AbdalwhabManager.swift
//  JobFinder
//
//  Created by Abdalwhab on 4/6/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import Foundation
import AFNetworking
class AbdalwhabManager {
    static var instance = AbdalwhabManager()
    var fillerByLonLat: Bool = false
    var long: String = ""
    var lat: String = ""
    var baseURL = ["https://jobs.github.com/","https://jobs.search.gov/"]
    var selectedBaseURL: String = ""
    var endPoint: EndPint!
    var selectedObject: AnyObject!
    func startNetworkMonitoring(){
        
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange({(status) in
            
            if status == AFNetworkReachabilityStatus.notReachable{
                self.topViewController()?.ShowNotifyType1(message: "no internet connection", theme: .error)
            }else{
            }
        })
    }
    public func topViewController() -> AbdalwhabVC?{
        
        return self.topViewControllerWithRootViewController(UIApplication.shared.keyWindow?.rootViewController)
    }
    private func topViewControllerWithRootViewController(_ rootViewController: UIViewController?) -> AbdalwhabVC?{
        
        if let navigationController = rootViewController as? UINavigationController {
            return topViewControllerWithRootViewController(navigationController.visibleViewController)
        } else if let tabBarController = rootViewController as? UITabBarController {
            return topViewControllerWithRootViewController(tabBarController.selectedViewController)
        }
        return rootViewController as? AbdalwhabVC
    }
}
