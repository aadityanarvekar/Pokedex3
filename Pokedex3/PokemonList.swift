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
    
    
    func downloadPokemonDetails(pokeId: Int, completed: @escaping PokemonDetailsDownloadComplete) {
        let selectedPoke = pokemonWithId(id: pokeId)
        let pokemonDetailsDownloadUrl = URL(string: "\(BASE_URL)\(POKEMON_END_POINT)\(pokeId)")!
        
        URLSession.shared.dataTask(with: pokemonDetailsDownloadUrl) { (data: Data?, response: URLResponse?, err: Error?) in
            guard err == nil && data != nil else {
                print("Error donwloading pokemon degtails. Error: \(err.debugDescription)")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                if let dict = json as? Dictionary<String, Any> {
                    if let height = dict["height"] as? String {
                        selectedPoke.height = height
                    }
                    
                    if let weight = dict["weight"] as? String {
                        selectedPoke.weight = weight                        
                    }
                    
                    if let defense = dict["defense"] as? Int {
                        selectedPoke.defenseAsInt = defense
                    }
                    
                    if let attack = dict["attack"] as? Int {
                        selectedPoke.baseAttackAsInt = attack
                    }
                    
                    if let types = dict["types"] as? [Dictionary<String, Any>] {
                        for i in 0 ..< types.count {
                            if let name = types[i]["name"] as? String {
                                if i >= 1 {
                                    selectedPoke.type.append("/")
                                }
                                selectedPoke.type.append(name.capitalized)
                            }
                        }
                    }
                    
                    if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>] {
                        if evolutions.count > 0, let to = evolutions[0]["to"] as? String {
                            selectedPoke.nextEvolutionPokemon = self.pokemonWithName(name: to)
                        }
                    }
                    
                    
                    if let descriptions = dict["descriptions"] as? [Dictionary<String, Any>] {
                        if descriptions.count > 0 {
                            if let resource_uri = descriptions.first!["resource_uri"] as? String {
                                let pokeDescriptionUrl = URL(string: "http://pokeapi.co\(resource_uri)")!
                                URLSession.shared.dataTask(with: pokeDescriptionUrl, completionHandler: { (data: Data?, response: URLResponse?, err: Error?) in
                                    if err == nil && data != nil {
                                        do {
                                            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                                            if let detailsDict = json as? Dictionary<String, Any> {
                                                if let description = detailsDict["description"] as? String {
                                                    selectedPoke.description = description
                                                    completed(true)
                                                }
                                            }
                                        } catch let jsonError as NSError {
                                            print("Error creating JSON for details: \(jsonError.debugDescription)")
                                            
                                        }
                                    } else {
                                        print("Error downloading details for pokemon: \(err.debugDescription))")                                        
                                    }
                                }).resume()
                            }
                            
                        }
                    }
                    completed(false)
                    
                }
            } catch let err as NSError {
                print("Error creating JSON object: \(err.debugDescription)")
            }
            
        }.resume()
        
        
    }
    
}
