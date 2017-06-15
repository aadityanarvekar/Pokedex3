//
//  PokemonCell.swift
//  Pokedex3
//
//  Created by AADITYA NARVEKAR on 6/4/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 7.5
        self.layer.masksToBounds = true
    }
    
    func configurePokeCell(_ pokemon: Pokemon) {
        pokemonImg.image = UIImage(named: "\(pokemon.pokedexId)")
        pokemonName.text = pokemon.name.capitalized
    }
    
}
