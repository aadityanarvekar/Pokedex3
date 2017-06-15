//
//  ViewController.swift
//  Pokedex3
//
//  Created by AADITYA NARVEKAR on 6/3/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var audioPlayer = AVAudioPlayer()
    
    var filteredPokemon: [Pokemon] = []
    var inSearchMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up search bar delegate
        searchBar.delegate = self
        
        // Set up collection view delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Ready the model
        PokemonList.sharedInstace.constructPokemonList()
        
        // Set up audio 
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = 0.075
            audioPlayer.enableRate = true
            audioPlayer.rate = 1.5
            audioPlayer.prepareToPlay()
            //audioPlayer.play()
        } catch let err as NSError {
            print("Error initializaing audio player: \(err.debugDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return PokemonList.sharedInstace.getFilteredPokemonListCount()
        }
        
        return PokemonList.sharedInstace.getCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as? PokemonCell {
            var pokemon: Pokemon!
            if inSearchMode {
                pokemon = PokemonList.sharedInstace.getPokemonAtIndexInFilteredList(index: indexPath.row)
            } else {
                pokemon = PokemonList.sharedInstace.getPokemonAtIndex(index: indexPath.row)
            }
            cell.configurePokeCell(pokemon)
            return cell
        } else {
            print("Error in cell for item at index path")
        }
        
        return PokemonCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let poke: Pokemon!
        if inSearchMode {
            poke = PokemonList.sharedInstace.getPokemonAtIndexInFilteredList(index: indexPath.row)
        } else {
            poke = PokemonList.sharedInstace.getPokemonAtIndex(index: indexPath.row)
        }
        
        performSegue(withIdentifier: "PokenonDetailVC", sender: poke)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    
    @IBAction func toggleMusicBtnTapped(_ sender: Any) {
        let btn = sender as? UIButton
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            btn?.alpha = 0.5
        } else {
            audioPlayer.currentTime = 0.0
            audioPlayer.play()
            btn?.alpha = 1.0
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            inSearchMode = false            
        } else {
            inSearchMode = true
            PokemonList.sharedInstace.filterPokemonListWith(filterString: searchText.lowercased())
        }
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        inSearchMode = false
        searchBar.text = ""
        //searchBar.placeholder = "Search Pokemon..."
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PokemonDetailVC, let poke = sender as? Pokemon {
            destination.selectedPokemon = poke
        }
    }

}

