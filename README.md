# Smack

### Structure

![screen shot 2018-03-30 at 11 00 22 pm](https://user-images.githubusercontent.com/11573422/38153749-95d42a98-346e-11e8-9237-2c51e673b7db.png)

![screen shot 2018-03-30 at 11 05 26 pm](https://user-images.githubusercontent.com/11573422/38153843-0455843a-346f-11e8-9a8a-8eb0d7534976.png)

#### AuthService 
    import Foundation
    import Alamofire
    import SwiftyJSON
    class AuthService {
             static let instance = AuthService()  //SingleTone

//Include all Data related to User Authentication

   //Create userdefaults to store Userdata like email id , name etc
   
   //Register User with Alamofire
   
   //Login User with Alamofire
   
   // Add User with Alamofire
   
   // Find User With Email Id
   
   // Set UserInfor ---> UserImage , AvtarColor , UserName etc


     //Create userdefaults to store Userdata like email id , name etc
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    
    var authToken : String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
 
 ---
   
      //Register User with Alamofire
    func registerUser (email : String, password: String, completion: @escaping ComplitionHandler){
        
        let lowerCaseEmail = email.lowercased()
      
        
        let body : [String : Any] = [
            "email" : lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
 ---
    
    //Login User with Alamofire
    func loginUser (email : String, password: String, completion: @escaping ComplitionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        
        let body : [String : Any] = [
            "email" : lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
     //-------------------------   Without Using SwiftyJSON .  ------------------------------------------------//           
              /*  if let json = response.result.value as? Dictionary<String,Any> {
                    if let email = json ["user"] as? String {
                        self.userEmail = email
                    }
                    if let token = json ["token"] as? String {
                        self.authToken = token
                    }
                }*/
     //-------------------------------------------------------------------------------------------------------------           
                //Using Swifty JSON
                guard let data = response.data else {return}
                
                do {
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    print(json)
                } catch {
                    print(error)
                    // or display a dialog
                }
                self.isLoggedIn = true
               
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
 ##### JSONParsing with SingleLline Code and Without Signle Line (Codable)
    
      // MARK:- Find All Channel
    func findAllChannel(complition: @escaping ComplitionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                
      //-------------------------    //Swift 4 way in one line  ----------------------------------//
              /*  do {
                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
                    print(self.channels)
                } catch let error {
                    debugPrint(error as Any)
                }*/
     //------------------------------------------------------------------------------------------------//              
                //Default Way (Preferable Way)
                do {
                    if let json = try JSON(data:data).array {
                        for item in json {
                            let name = item["name"].stringValue
                            let channelDescription = item["description"].stringValue
                            let id = item["_id"].stringValue
                            let channel = Channel (channelTitle: name, channelDescription: channelDescription, id: id)
                            self.channels.append(channel)
                        }
                       
                    }
                    
                } catch {
                    print(error)
                }
                
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                complition(true)
                
            } else {
                complition(false)
                print(response.result.error as Any)
            }
        }
    }
    
 #### Model with Codable and Without Codable
 
    import Foundation

    struct Channel {
       public private(set) var channelTitle : String!
       public private(set) var channelDescription : String!
       public private(set) var id : String!
    }


     //----------------------   //Swift 4 way .  ---------------------------------------------------------------//
    /*struct Channel: Decodable {    //All key in Same Order and As Same name for Encode and Decode Json as Swift4
      public private(set) var _id : String!
      public private(set) var name : String!
      public private(set) var description : String!
      public private(set) var __v : Int?
      }*/
    //--------------------------------------------------------------------------------------------------------------

 
