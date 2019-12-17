//
//  AustellModel.swift
//  PassionProjectDraft1
//
//  Created by Krystal Campbell on 11/20/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

// MARK: - Welcome
struct Welcome: Codable {
    let type: String
    let features: [Feature]
    let total: Int
    
    enum JSONError: Error {
              case decodingError(Error)
          }
          
          static func getStreetSigns() -> [Feature] {
              guard let fileName = Bundle.main.path(forResource: "austell2", ofType: "json")
                  else {fatalError()}
              let fileURL = URL(fileURLWithPath: fileName)
              do {
                  let data = try Data(contentsOf: fileURL)
                  let signs = try
                    JSONDecoder().decode(Welcome.self, from: data)
                return signs.features
                    
              } catch {
                  fatalError("\(error)")
              }
          }
}

// MARK: - Feature
struct Feature: Codable {
    let type: String
    let properties: Properties
    let geometry: Geometry
    
       
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
    
}

// MARK: - Properties
struct Properties: Codable {
   // let id: Int
   // let orderNumber, sos: String
  //  let sosNew: [String]
    let onStreet, fromStreet, toStreet: String
    let signDescription: String
   // let facingDirectionType: JSONNull?
   // let arrowPoints: String?
    let distanceFromIntersection: Int
    let signCategory, signSubtype: String
  //  let lastWorkDate, notes: String?

    enum CodingKeys: String, CodingKey {
       // case id
        //case orderNumber = "order_number"
        //case sos
        //case sosNew = "sos_new"
        case onStreet = "on_street"
        case fromStreet = "from_street"
        case toStreet = "to_street"
      //  case smoCode = "smo_code"
        case signDescription = "sign_description"
       // case sizeDescription = "size_description"
     //   case facingDirectionType = "facing_direction_type"
       // case arrowPoints = "arrow_points"
        case distanceFromIntersection = "distance_from_intersection"
        case signCategory = "smo_category"
        case signSubtype = "smo_subtype"
       // case lastWorkDate = "last_work_date"
       // case notes
    }
}

