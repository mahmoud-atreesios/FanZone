//
//  HighlightsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 01/02/2024.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class HighlightsVC: UIViewController {
    
    @IBOutlet weak var highlightsTableView: UITableView!
    
    var viewModel = ViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NavBar.applyCustomNavBar(to: self)
        
        highlightsTableView.register(UINib(nibName: "HighlightsTableViewCell", bundle: nil), forCellReuseIdentifier: "highlightCell")
        
        viewModel.getHighlightsData()
        bindingHighlightsTableViewToViewModel()
        
    }
}

extension HighlightsVC: HighlightsTableViewCellDelegate{
    
    func didTapImage(url: URL?) {
        if let url = url {
            self.performSegue(withIdentifier: "ShowVideoWebPage", sender: url)
        }
    }
    
    func bindingHighlightsTableViewToViewModel() {
        viewModel.highlightsResult
            .bind(to: highlightsTableView.rx.items(cellIdentifier: "highlightCell", cellType: HighlightsTableViewCell.self)) { [weak self] row, result, cell in
                guard let self = self else { return }
                cell.highlightsImageView.sd_setImage(with: URL(string: result.thumbnail ?? "highlight1"))
                cell.delegate = self
                cell.url = URL(string: result.matchviewURL ?? "")
                cell.matchLabel.text = result.title
                
                // Cell UI
                cell.highlightsImageView.layer.cornerRadius = 10.0
                cell.highlightsImageView.layer.borderWidth = 1.0
                cell.matchLabel.layer.cornerRadius = 10.0
                cell.highlightsImageView.layer.borderColor = UIColor.lightGray.cgColor
                cell.highlightsImageView.clipsToBounds = true
            }
            .disposed(by: disposeBag)
    }
}
extension HighlightsVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVideoWebPage",
           let destinationVC = segue.destination as? VideoWebViewVC,
           let url = sender as? URL {
            destinationVC.url = url
        }
    }
}

