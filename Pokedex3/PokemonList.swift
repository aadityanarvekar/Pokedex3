//
//  PokemonList.swift
//  Pokedex3
//
//  Created by AADITYA NARVEKAR on 6/5/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import Foundation

class PokemonList {
    static var sharedInstace = PokemonList()
    
    private var _pokemonList: [Pokemon] = []
    var pokemonList: [Pokemon] {
        return _pokemonList
    }
    
    private var _filteredPokemonList: [Pokemon] = []
    var filteredPokemonList: [Pokemon] {
        return _filteredPokemonList
    }
    
    
    func constructPokemonList() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                var pokedexId: Int!
                var pokemonName: String!
                if let name = row["identifier"] {
                    pokemonName = name.capitalized
                }
                
                if let id = row["id"] {
                    pokedexId = Int(id)
                }
                
                if pokedexId != -1 {
                    let pokemon = Pokemon(name: pokemonName, id: pokedexId)
                    _pokemonList.append(pokemon)
                }
            }
        } catch let err as NSError {
            print("Error encountered when parsing CSV: \(err.debugDescription)")
        }
        
    }
    
    func getCount() -> Int {
        return _pokemonList.count
    }
    
    func getPokemonAtIndex(index: Int) -> Pokemon {
        return _pokemonList[index]
    }
    
    func filterPokemonListWith(filterString: String) {
        _filteredPokemonList = pokemonList.filter({ (poke) -> Bool in
            return poke.name.lowercased().contains(filterString)
        })
    }
    
    func getFilteredPokemonListCount() -> Int {
        return filteredPokemonList.count
    }
    
    func getPokemonAtIndexInFilteredList(index: Int) -> Pokemon {
        return _filteredPokemonList[index]
    }
    
    func pokemonWithId(id: Int) -> Pokemon {
        for poke in _pokemonList {
            if poke.pokedexId == id {
                return poke
            }
        }
        
        return Pokemon(name: "-", id: 0)
    }
    
    func pokemonWithName(name: String) -> Pokemon {
        for poke in _pokemonList {
            if poke.name.lowercased() == name.lowercased() {
                return poke
            }
        }
        
        return Pokemon(name: "-", id: 0)
    }
    
}
