//
//  NewsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 01/02/2024.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class NewsVC: UIViewController {
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var newsTableView: UITableView!
    
    var viewModel = ViewModel()
    var disposeBag = DisposeBag()
    
    var timer: Timer?
    var currentIndex = 0
    
    var plStadArray = ["PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3","PL1","PL2","PL3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NavBar.applyCustomNavBar(to: self)
        newsTableView.isScrollEnabled = false
        
        trendingCollectionView.register(UINib(nibName: "TrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "trendCell")
        newsTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        
        viewModel.getTrendingNewsData()
        viewModel.getNewsData()
        
        bindTrendingCollectionViewToViewModel()
        bindNewsTableViewToViewModel()
    }
}

extension NewsVC{
    func bindTrendingCollectionViewToViewModel(){

        viewModel.trendingNewsDataResult
            .map { result in
                // Filter and take the first 5 elements
                return result.prefix(5)
            }
            .catch { error in
                let alert = UIAlertController(title: "Error", message: "Failed to fetch news data. Would you like to retry?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self.viewModel.getNewsData() // Retry the API call
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return Observable.just([])
            }
            .bind(to: trendingCollectionView.rx.items(cellIdentifier: "trendCell", cellType: TrendingCollectionViewCell.self)) { row, result, cell in

                cell.trendImageView.sd_setImage(with: URL(string: result.img ?? "PL"))
                //cell.newsLabel.text = newsResult.modifiedTitle
                cell.newsLabel.text = result.title

                //Cell UI
                cell.contentView.layer.borderWidth = 1.0
                cell.contentView.layer.cornerRadius = 10.0
                cell.contentView.layer.masksToBounds = true
            }
            .disposed(by: disposeBag)
    }
}

extension NewsVC{
    
    func bindNewsTableViewToViewModel(){
        viewModel.newsDataResult
            .catch { error in
                let alert = UIAlertController(title: "Error", message: "Failed to fetch news data. Would you like to retry?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self.viewModel.getNewsData() // Retry the API call
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return Observable.just([])
            }
            .bind(to: newsTableView.rx.items(cellIdentifier: "newsCell", cellType: NewsTableViewCell.self)){row,result,cell in
                
                cell.newsImageView.sd_setImage(with: URL(string: result.img ?? "PL"))
                cell.newsTitle.text = result.title
                
                let tapGesture = UITapGestureRecognizer()
                cell.addGestureRecognizer(tapGesture)
                
                tapGesture.rx.event
                    .bind { tapped in
                        self.performSegue(withIdentifier: "ShowWebPageSegue", sender: result)
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

extension NewsVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWebPageSegue",
           let destinationVC = segue.destination as? NewsWebVC,
           let result = sender as? NewsModel,
           let urlString = result.url,
           let url = URL(string: urlString) {
            destinationVC.url = url
        } else {
            print("Segue not properly configured.")
        }
    }
}


// MARK: - Automatic scroll of page control
extension NewsVC{
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        stopAutoScrolling()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAutoScrolling()
    }
    
    func startAutoScrolling(){
        // Schedule a timer to change the page
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
        
        pageControl.layer.cornerRadius = 10.0
        pageControl.layer.masksToBounds = true
    }
    
    func stopAutoScrolling(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc func scrollToNextPage(){
        guard trendingCollectionView.numberOfItems(inSection: 0) > 0 else {
            // No items in the collection view, show alert and return
            let alert = UIAlertController(title: "No Data", message: "There are no items to display.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            // Retry the API call
            viewModel.getNewsData()
            
            return
        }
        
        // Calculate the next page index
        let nextPage = (currentIndex + 1) % pageControl.numberOfPages
        
        // Scroll to the next page
        trendingCollectionView.scrollToItem(at: IndexPath(item: nextPage, section: 0), at: .centeredHorizontally, animated: true)
        
        // Update the current index
        currentIndex = nextPage
        
        // Update the page control
        pageControl.currentPage = nextPage
    }
}
