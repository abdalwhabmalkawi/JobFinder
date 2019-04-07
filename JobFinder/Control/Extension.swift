//
//  Extension.swift
//  JobFinder
//
//  Created by Abdalwhab on 4/6/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
let imageCache = NSCache<NSString, UIImage>()
class CustomUIButton: UIButton {
    @IBInspectable
    var ifCircle: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable
    var radius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable
    var borderColor: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if ifCircle {
            self.layer.cornerRadius = self.bounds.width / 2
        }else {
            self.layer.cornerRadius = self.radius
        }
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
    }
}


class CustomUIView: UIView {
    @IBInspectable
    var ifCircle: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable
    var radius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable
    var borderColor: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if ifCircle {
            self.layer.cornerRadius = self.bounds.width/2
        }else {
            self.layer.cornerRadius = self.radius
        }
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
    }

}
extension String
{
    func convertDateString() -> String? {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "ccc MMM dd HH:mm:ss 'UTC' yyyy"
        if let newDate = dateFormate.date(from: self){
            dateFormate.dateFormat = "dd/MM/yyyy"
            let newDateString = dateFormate.string(from: newDate)
            return newDateString
        }
        return nil
    }
}
extension UIImageView {
    func Load(imgURL: String){
        if let imageToCache = imageCache.object(forKey: imgURL as NSString) {
            self.image = imageToCache
            return
        }
        DispatchQueue.main.async {
            let indecator = UIActivityIndicatorView(frame: CGRect(x: self.bounds.width/2 - 25, y: self.bounds.height/2 - 25, width: 50, height: 50))
            indecator.style = .white
            indecator.color = .black
            if imgURL != "" {
                indecator.startAnimating()
                self.addSubview(indecator)
                Alamofire.request(imgURL).responseImage { (response) in
                    indecator.stopAnimating()
                    indecator.removeFromSuperview()
                    if let image = response.value {
                        let imageToCache = image
                        imageCache.setObject(imageToCache, forKey: imgURL as NSString)
                        self.image = imageToCache
                    }else {
                        self.image = UIImage(named: "Default")
                    }
                }
            }else {
                self.image = UIImage(named: "Default")
            }
        }
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
