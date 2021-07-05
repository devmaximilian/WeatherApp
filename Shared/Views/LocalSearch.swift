//
//  LocalSearch.swift
//  WeatherApp
//
//  Created by Maximilian Wendel on 2021-07-05.
//

import SwiftUI
import MapKit

struct LocalSearch: View {
    @StateObject var lsvm: LocalSearchViewModel
    @State var isSearching: Bool = false
    @State var location: MKLocalSearchCompletion? = nil
    
    var body: some View {
        VStack {
            if let location = location {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(location.title)
                            .font(.headline)
                        if !location.subtitle.isEmpty {
                            Text(location.subtitle)
                                .font(.subheadline)
                        }
                    }
                    Spacer()
                    Button("Edit") {
                        isSearching = true
                    }
                }
            } else {
                Button("Choose location") {
                    isSearching = true
                }
            }
            
        }.sheet(isPresented: $isSearching, content: {
            LocalSearchSheet(select: { item in
                self.location = item
                self.isSearching = false
            }, dismiss: { isSearching = false }).environmentObject(lsvm)
        })
    }
}

struct LocalSearchSheet: View {
    @EnvironmentObject var lsvm: LocalSearchViewModel
    
    var select: ((MKLocalSearchCompletion) -> Void)
    var dismiss: (() -> Void)
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search by location name...", text: .init(get: { lsvm.searchQuery }, set: { string in lsvm.searchQuery = string }))
                    .padding()
                if case .loaded(let results) = lsvm.state {
                    List(results) { result in
                        Button(result.title) {
                            select(result)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Choose location"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: dismiss, label: { Text("Done").bold() }))
        }
        .onAppear {
            lsvm.initialize()
        }
    }
}

struct LocalSearch_Previews: PreviewProvider {
    static var previews: some View {
        LocalSearch(lsvm: .init(state: .waitingForInput))
    }
}
