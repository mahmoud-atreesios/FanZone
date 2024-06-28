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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var highlightsTableView: UITableView!
    
    var noResultsLabel: UILabel!
    
    var viewModel = ViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        setupNoResultsLabel()
        viewModel.getHighlightsData()
        bindingHighlightsTableViewToViewModel()
        setupSearchBar()
    }
}

// MARK: - highlight tableview
extension HighlightsVC: HighlightsTableViewCellDelegate{
    func didTapImage(url: URL?) {
        if let url = url {
            self.performSegue(withIdentifier: "ShowVideoWebPage", sender: url)
        }
    }
    
    func bindingHighlightsTableViewToViewModel(){
        Observable.combineLatest(viewModel.highlightsResult, viewModel.searchText) { highlights, searchText in
            guard !searchText.isEmpty else {
                return highlights
            }
            return highlights.filter { highlight in
                return highlight.title?.lowercased().contains(searchText.lowercased()) ?? true
            }
        }
        .do(onNext: { [weak self] filteredHighlights in
            DispatchQueue.main.async {
                self?.noResultsLabel.isHidden = !filteredHighlights.isEmpty
            }
        })
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

// MARK: - search logic
extension HighlightsVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        viewModel.searchText.accept(searchText)
    }
    
    func setupSearchBar() {
        searchBar.placeholder = "Search highlights"
        searchBar.delegate = self
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.viewModel.searchText.accept("")
            })
            .disposed(by: disposeBag)
    }
    
    func setupNoResultsLabel(){
        noResultsLabel = UILabel()
        noResultsLabel.isHidden = true
        noResultsLabel.text = "No results found"
        noResultsLabel.textAlignment = .center
        noResultsLabel.textColor = .gray
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noResultsLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - intial setup
extension HighlightsVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVideoWebPage",
           let destinationVC = segue.destination as? VideoWebViewVC,
           let url = sender as? URL {
            destinationVC.url = url
        }
    }
}

extension HighlightsVC{
    func setup(){
        NavBar.applyCustomNavBar(to: self)
        highlightsTableView.register(UINib(nibName: "HighlightsTableViewCell", bundle: nil), forCellReuseIdentifier: "highlightCell")
        hideKeyboardWhenTappedAround()
    }
}

// MARK: - HIDE KEYBOARD
extension HighlightsVC{
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(HighlightsVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
