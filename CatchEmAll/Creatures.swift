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
        var next: String?
        var results: [Creature]
    }
    var urlString = "https://pokeapi.co/api/v2/pokemon/"
    var count = 0
    var creaturesArray: [Creature] = []
    var isLoading = false
    func getData() async {
        print("We are accessing the url \(urlString)")
        isLoading = true
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not create a url from \(urlString)")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("ERROR: Could not decode returned JSON data")
                isLoading = false
                return
            }
            Task { @MainActor in
                self.count = returned.count
                self.urlString = returned.next ?? ""
                self.creaturesArray = self.creaturesArray + returned.results
                isLoading = false
            }
        } catch {
            print("ERROR: Could not get data from \(urlString)")
            isLoading = false
        }
    }
    
    func loadNextIfNeeded(creature: Creature) async {
        guard let lastCreature = creaturesArray.last else { return }
        if creature.id == lastCreature.id && urlString.hasPrefix("http") {
            await getData()
        }
    }
    
    func loadAll() async {
        Task { @MainActor in
            guard urlString.hasPrefix("http") else { return }
            await getData()
            await loadAll()
        }
    }
}

