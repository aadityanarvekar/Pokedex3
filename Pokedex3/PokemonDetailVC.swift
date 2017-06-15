//
//  PokemonDetailVC.swift
//  Pokedex3
//
//  Created by AADITYA NARVEKAR on 6/9/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    private var _selectedPokemon: Pokemon!
    var selectedPokemon: Pokemon {
        get {
            return _selectedPokemon == nil ? Pokemon(name: "-", id: 0) : _selectedPokemon
        }
        
        set {
            _selectedPokemon = newValue
        }
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var nextEvolutionLbl: UILabel!
    @IBOutlet weak var currentEvolutionImg: UIImageView!
    @IBOutlet weak var nextEvolutionImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBasicPokemonInfo()
        PokemonList.sharedInstace.downloadPokemonDetails(pokeId: selectedPokemon.pokedexId) { completedDescriptionDownload in
            if completedDescriptionDownload {
                DispatchQueue.main.async {
                    self.updateDescriptionDetailsForPokemon()
                }
            } else {
                DispatchQueue.main.async {
                    self.updateDetailsForPokemon()
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func segmentBtnSelected(_ sender: Any) {
        if let seg = sender as? UISegmentedControl {
            print(seg.selectedSegmentIndex)
        }
    }
    
    func updateDetailsForPokemon() {
        descriptionTxt.scrollRangeToVisible(NSMakeRange(0, 0))
        heightLbl.text = selectedPokemon.height
        weightLbl.text = selectedPokemon.weight
        defenseLbl.text = selectedPokemon.defense
        baseAttackLbl.text = selectedPokemon.baseAttack
        typeLbl.text = selectedPokemon.type
        nextEvolutionLbl.text = "Next Evolution: \(selectedPokemon.nextEvolutionPokemon.name)"
        if selectedPokemon.nextEvolutionPokemon.name == "-" {
            nextEvolutionImg.isHidden = true
        } else {
            nextEvolutionImg.image = UIImage(named: "\(selectedPokemon.nextEvolutionPokemon.pokedexId)")
        }
    }
    
    func updateDescriptionDetailsForPokemon() {
        descriptionTxt.text = selectedPokemon.description
    }
    
    func updateBasicPokemonInfo() {
        nameLbl.text = selectedPokemon.name
        pokedexIdLbl.text = "\(selectedPokemon.pokedexId)"
        mainImg.image = UIImage(named: "\(selectedPokemon.pokedexId)")
        currentEvolutionImg.image = UIImage(named: "\(selectedPokemon.pokedexId)")
    }
}
