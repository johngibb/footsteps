//
//  SearchAPI.swift
//  Footsteps
//
//  Created by John Gibb on 6/19/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import MapKit

class SearchAPI {

    func search(text: String, results: @escaping (([Destination]) -> Void)) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = text

        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (localSearchResponse, error) -> Void in
            let found = localSearchResponse?.mapItems.map { item in
                return Destination(
                    name: item.name ?? "",
                    address: SearchAPI.address(placemark: item.placemark)
                )
            }
            results(found ?? [])
        }
    }

    private static func address(placemark: MKPlacemark) -> String {
        return [
            [placemark.subThoroughfare, placemark.thoroughfare].removeNils().joined(separator: " "),
            placemark.locality,
            placemark.administrativeArea,
            placemark.postalCode
        ].removeNils().joined(separator: ", ")
    }
}

