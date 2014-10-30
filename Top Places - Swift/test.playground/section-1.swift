// Playground - noun: a place where people can play

import UIKit
//
//let a = [ "places": [ "total": 1,
//    "place": [
//    [ "place_id": "hP_s5s9VVr5Qcg", "woeid": "44418", "latitude": 51.506, "longitude": -0.127, "place_url": "/United+Kingdom/England/London", "place_type": "locality", "place_type_id": 7, "timezone": "Europe/London", "_content": "London, England, United Kingdom", "woe_name": "London", "photo_count": "1734" ]]]] as NSDictionary


let closure = { print("2") }
closure()


var countries = ["United Kingdom", "Poland", "Zimbabwe"]
countries.sort(<)

// countries.reduce([Int: String](), combine: { (var mapping, country) -> [Int: String] in
//    mapping[0] = country
//    return mapping
//})

var set = NSMutableOrderedSet()
set.addObject("pl")
set.addObject("uk")

set.objectAtIndex(0)
set.addObject("pl")
set.objectAtIndex(0)
set.objectAtIndex(1)


//let (sectionToName, _) = countries.reduce((Dictionary<Int, String>(), 0)) {
//    (mapping, index), country in
//    mapping[index] = country
//    return (mapping, index++)
//}
//self.sectionToName = sectionToName



