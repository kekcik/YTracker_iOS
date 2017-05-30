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
    var currentToken = ""
    var currentId = 0
    
    func login(phone: String, pw: String) {
        let parameters: Parameters = [
                "phone": phone,
                "password": pw
        ]
        Alamofire.request(address + "user.auth", parameters: parameters).responseJSON { response in
            if let jsonServer = response.result.value {
                let json = JSON(jsonServer)
                let code = json["result_code"].int!
                print("user.auth -> \(code)")
                switch code {
                case 0:
                    let token = json["token"].string!
                    let id = json["id"].int!
                    self.currentToken = token
                    self.currentId = id
                    NotificationCenter.default.post(name: Notification.Name("loginSuccess"), object: nil)
                    break
                case 40:
                    NotificationCenter.default.post(name: Notification.Name("loginWrongLoginPass"), object: nil)
                    break
                default:
                    NotificationCenter.default.post(name: Notification.Name("loginFailed"), object: nil)
                    break
                }
            }
        }
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
                print("user.register_auth -> \(code)")
                switch code {
                case 0:
                    self.currentToken = json["token"].string!
                    self.currentId = json["id"].int!
                    NotificationCenter.default.post(name: NSNotification.Name("registerSuccess"), object: nil)
                    return
                case 80:
                    NotificationCenter.default.post(name: NSNotification.Name("registerWrongPhone"), object: nil)
                    return
                default:
                    NotificationCenter.default.post(name: NSNotification.Name("registerFail"), object: nil)
                    return
                }

            }
        }
    }
}
