//
//  Card.swift
//  LetsDoIt
//
//  Created by Tran Gia Huy on 5/10/18.
//  Copyright © 2018 HD. All rights reserved.
//

import UIKit

struct Card: Codable {
    var cardImage: String
    var cardTitle:String
    
    init(cardImage:String, cardTitle:String) {
        self.cardImage = cardImage
        self.cardTitle = cardTitle
    }
}


// struct, class, enum can confirm Codable.
//import UIKit
//enum Gender: Int, Codable {
//    case male
//    case female
//}
//
//struct Person: Codable {
//    var name: String
//    var age: Int
//    var sex: Gender
//}
//
//var dungdo = Person(name: "Dung Do", age: 26, sex: .male)
//var data: Data = try! JSONEncoder().encode(dungdo)
//dungdo = try! JSONDecoder().decode(Person.self, from: data)
//print(dungdo.name)
//
//var arrPerson = [dungdo, dungdo, dungdo]
//data = try! JSONEncoder().encode(arrPerson)
//arrPerson = try! JSONDecoder().decode([Person].self, from: data)
//print(arrPerson[2])
