//
//  Item.swift
//  Todoey
//
//  Created by Ricardo Vera Abarca on 5/11/19.
//  Copyright © 2019 Ricardo Vera Abarca. All rights reserved.
//

import Foundation
class Item : Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
