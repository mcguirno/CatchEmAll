//
//  Creatures.swift
//  CatchEmAll
//
//  Created by Noah McGuire on 3/17/25.
//

import Foundation

@Observable
class Creatures {
    private struct Returned: Codable {
        var count: Int
        var next: String
        var results: [Result]
    }
    struct Result: Codable, Hashable {
        var name: String
        var url: String
    }
    var urlString = "https://pokeapi.co/api/v2/pokemon/"
    var count = 0
    var creaturesArray: [Result] = []
    func getData() async {
        print("We are accessing the url \(urlString)")
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not create a url from \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("ERROR: Could not decode returned JSON data")
                return
            }
            self.count = returned.count
            self.urlString = returned.next
            self.creaturesArray = returned.results
        } catch {
            print("ERROR: Could not get data from \(urlString)")
        }
    }
}

