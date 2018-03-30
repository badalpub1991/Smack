//
//  Channel.swift
//  Smack
//
//  Created by badal shah on 29/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import Foundation

struct Channel {
    public private(set) var channelTitle : String!
    public private(set) var channelDescription : String!
    public private(set) var id : String!
}


//Swift 4 way
/*struct Channel: Decodable {    //All key in Same Order and As Same name for Encode and Decode Json as Swift4
    public private(set) var _id : String!
    public private(set) var name : String!
    public private(set) var description : String!
    public private(set) var __v : Int?

}*/
