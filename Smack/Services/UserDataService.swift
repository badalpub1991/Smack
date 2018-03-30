//
//  UserDataService.swift
//  Smack
//
//  Created by badal shah on 27/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import Foundation
class UserDataService{
    static let instance = UserDataService()
    
    //public getter means other classes can read it. private(set) means other class can't read variable directly. other class can only change the Value of id.
    public private(set) var  id = ""
    public private(set) var avtarColor = ""
    public private(set) var avtarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData (id : String, color : String, avtarName: String, email: String, name: String) {
        self.id = id
        self.avtarColor = color
        self.avtarName = avtarName
        self.email = email
        self.name = name
    }
    
    func setAvtarName (avtarName : String) {
        self.avtarName = avtarName
    }
    
    func returnUIColor (components : String) -> UIColor {
        
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        var r, g, b, a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else { return defaultColor }
        guard let gUnwrapped = g else { return defaultColor }
        guard let bUnwrapped = b else { return defaultColor }
        guard let aUnwrapped = a else { return defaultColor }
        
        let rfloat = CGFloat(rUnwrapped.doubleValue)
        let gfloat = CGFloat(gUnwrapped.doubleValue)
        let bfloat = CGFloat(bUnwrapped.doubleValue)
        let afloat = CGFloat(aUnwrapped.doubleValue)

        let newUIColor = UIColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        return newUIColor
    }
    
    func logoutUser() {
        self.id = ""
        self.avtarColor = ""
        self.avtarName = ""
        self.email = ""
        self.name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        MessageService.instance.removeChannels()
        MessageService.instance.cleareMessages()
    }
}
