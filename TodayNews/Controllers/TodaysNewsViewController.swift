//
//  TodaysNewsViewController.swift
//  TodayNews
//
//  Created by Manish Kumar on 27/11/21.
//

import UIKit

class TodaysNewsViewController: UIViewController {
    
    @IBOutlet weak var todaysNewsTableView: UITableView!
    
    let reachability = Reachability()!
    
    var todayNewsDataArray: [Articles]? = []

    var currentPage: Int = 1
    var currentLanguage: String = "us"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Todays News"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 0.56, green: 0.76, blue: 0.38, alpha: 1.0)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //Create and set Navigation bar title
        setRightNavBarButtonTitle(language: currentLanguage)
        
        //UITableview setup
        todaysNewsTableView.rowHeight = UITableView.automaticDimension
        todaysNewsTableView.estimatedRowHeight = 180
        todaysNewsTableView.tableFooterView = UIView()

        //Registering TableView cells
        registerCells()
        
        //Fetching list of movies
        fetchNewsData(page_number: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func registerCells() {
        todaysNewsTableView.register(UINib(nibName: "TodayNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "TodayNewsTableViewCell")
    }
    
    func setRightNavBarButtonTitle(language: String) {
        var title = "English"
        if language == "us" {
            title = "French"
        }
        
        let languageButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.languageChanged))
        self.navigationItem.rightBarButtonItem = languageButton
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.red]
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
    }
    
    @objc func languageChanged() {
        
        if currentLanguage == "us" {
            currentLanguage = "fr"
        } else {
            currentLanguage = "us"
        }
        
        //Change Navigation bar button title
        setRightNavBarButtonTitle(language: currentLanguage)
        
        //Clear Cache and make current page to 1
        currentPage = 1
        todayNewsDataArray?.removeAll()
        
        //Call API and get response for the New language selected
        fetchNewsData(page_number: currentPage)
    }
    
    func fetchNewsData(page_number: Int) {
        
        if reachability.currentReachabilityStatus == .notReachable {
            return
        }
        
        let params = [
            "country" : currentLanguage,
            "category" : Appkeys.APP_NEWS_CATEGORY,
            "apiKey" : Appkeys.APP_API_KEY,
            "pageSize" : 5,
            "page" : page_number
            ] as [String : Any]
        
        //Web service call for fetching list of News
        Webservices().callGetService(methodName: WebServiceMethods.WS_TOP_HEADLINES, params: params, successBlock: { (data) in
            do {
                let jsonDecoder = JSONDecoder()
                //Parsing data
                let newsResponse : TodaysNewsResponse = try jsonDecoder.decode(TodaysNewsResponse.self, from: data)
                
                //Checking and appending data to the movies data array
                self.todayNewsDataArray = self.todayNewsDataArray?.count == 0 ? newsResponse.articles : (self.todayNewsDataArray ?? []) + (newsResponse.articles ?? [])
                                
                DispatchQueue.main.async {
                    self.todaysNewsTableView.reloadData()
                }
            } catch {
                
            }
        }) { (error) in
            
        }
    }
}


extension TodaysNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayNewsDataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayNewsTableViewCell", for: indexPath) as! TodayNewsTableViewCell
        
        let newsData = todayNewsDataArray?[indexPath.row]
        
        cell.newsImageView.loadImage(newsData?.urlToImage ?? "")
        
        cell.titleValueLabel.text = newsData?.title ?? "-"
        cell.authorValueLabel.text = newsData?.author ?? "-"
        cell.descriptionValueLabel.text = newsData?.description ?? "-"
        
        if currentLanguage == "us" {
            cell.titleLabel.text = "Title:"
            cell.authorLabel.text = "Author:"
            cell.descriptionLabel.text = "Description:"
            
        } else {
            cell.titleLabel.text = "Titre:"
            cell.authorLabel.text = "Auteur:"
            cell.descriptionLabel.text = "La description:"
        }

        cell.selectionStyle = .none
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
        
    }
}

// MARK:- UIScrollView Delegates
extension TodaysNewsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            fetchNewsData(page_number: currentPage + 1)
        }
    }
}
