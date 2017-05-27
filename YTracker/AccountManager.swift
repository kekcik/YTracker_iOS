//
//  AccountManager.swift
//  YTracker
//
//  Created by Ivan Trofimov on 27.05.17.
//  Copyright © 2017 Ivan Trofimov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class AccountManager {
    static let sh = AccountManager()
    private let address = "http://109.120.159.112:4567/"
    func login() {
        
    }
    func register(name: String, phone: String, pw: String) {
        let parameters: Parameters = [
            "phone": phone,
            "name": name,
            "password": pw
        ]
        Alamofire.request(address + "user.register_auth", parameters: parameters).responseJSON { response in
            if let jsonServer = response.result.value {
                let json = JSON(jsonServer)
                let code = json["result_code"].int!
                print(code)
                switch code {
                case 0 :
                    NotificationCenter.default.post(name: NSNotification.Name("registerSuccess"), object: json["token"].string)
                    break
                case 80:
                    NotificationCenter.default.post(name: NSNotification.Name("registerWrongPhone"), object: nil)
                    break
                default:
                    break
                }
            }
        }
    }
}
