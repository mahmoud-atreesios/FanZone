//
//  OnboardingVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 19/05/2024.
//

import UIKit

class OnboardingVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1{
                nextButton.setTitle("Get Started", for: .normal)
            }else{
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        slides = [OnboardingSlide(title: "Fanzone easy way to reserve match tickets", desc: "Fanzone is an easy way to be able to reserve football match tickets of your favourite teams", image: UIImage(named: "onboarding1")!),
                  OnboardingSlide(title: "Reserve for your family", desc: "Fanzone allow you to haave your beloved family members connected to your account so, you can book the ticket for your self and your childern", image: UIImage(named: "onboarding2")!),
                  OnboardingSlide(title: "Book Transportation!", desc: "Fanzone provide transportation for the stadiums destinantion so that you can book a bus for the match stadium", image: UIImage(named: "onboarding3")!)]
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if currentPage == slides.count - 1{
            print("goto next page")
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            if let windowScene = view.window?.windowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = tabBarController
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window = window
                window.makeKeyAndVisible()
            }
        }else{
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
}

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
}

extension OnboardingVC{
    func setupUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        nextButton.layer.cornerRadius = 10
        nextButton.layer.masksToBounds = true
        
        nextButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
    }
}
