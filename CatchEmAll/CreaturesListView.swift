//
//  ContentView.swift
//  CatchEmAll
//
//  Created by Noah McGuire on 3/17/25.
//

import SwiftUI

struct CreaturesListView: View {
    @State var creatures = Creatures()
    @State private var searchText = ""
    var body: some View {
        NavigationStack {
            ZStack {
                List(searchResults) { creature in
                    LazyVStack {
                        NavigationLink {
                            DetailView(creature: creature)
                        } label: {
                            Text("\(returnIndex(of: creature)). \(creature.name.capitalized)")
                                .font(.title2)
                        }
                    }
                    .task {
                        await creatures.loadNextIfNeeded(creature: creature)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Pokemon")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Load All") {
                            Task {
                                await creatures.loadAll()
                            }
                        }
                    }
                    ToolbarItem(placement: .status) {
                        Text("\(creatures.creaturesArray.count) of \(creatures.count)")
                    }
                }
                .searchable(text: $searchText)
                
                if creatures.isLoading {
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }
            }
        }
        .task {
            await creatures.getData()
        }
    }
    
    var searchResults: [Creature] {
        if searchText.isEmpty {
            return creatures.creaturesArray
        } else {
            return creatures.creaturesArray.filter {$0.name.capitalized.contains(searchText)}
        }
    }
    
    func returnIndex(of creature: Creature) -> Int {
        guard let index = creatures.creaturesArray.firstIndex(where: {$0.id == creature.id}) else {return 0}
        return index + 1
    }
}

#Preview {
    CreaturesListView()
}
