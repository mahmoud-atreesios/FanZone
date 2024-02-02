//
//  ViewController.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 31/01/2024.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {


    @IBOutlet weak var leagueCollectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    var arr = ["PL","laliga","EPL2","BL","CL","SA"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NavBar.applyCustomNavBar(to: self)
        leagueCollectionView.register(UINib(nibName: "LeagueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "leagueCell")
        setUpLeagueCollectionView()

    }

}

extension HomeVC{
    
    func setUpLeagueCollectionView(){
        Observable.just(arr)
            .bind(to: leagueCollectionView.rx.items(cellIdentifier: "leagueCell", cellType: LeagueCollectionViewCell.self)){row,image,cell in
                cell.leagueImageView.image = UIImage(named: image)
                
                // Make the cell circular
                cell.layer.cornerRadius = 35.8
                cell.clipsToBounds = true
                
                cell.leagueImageView.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1)
                cell.leagueImageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
            }
            .disposed(by: disposeBag)
    }
}

