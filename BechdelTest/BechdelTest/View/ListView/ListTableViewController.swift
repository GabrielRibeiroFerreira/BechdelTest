//
//  ListTableViewController.swift
//  BechdelTest
//
//  Created by Gabriel Ferreira on 03/09/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    var presenter: ListPresenter!
    let cellIdentifier : String = "ListTableViewCell"
    var completeList: [Movie] = []
    var list: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ListPresenter()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib.init(nibName: self.cellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: self.cellIdentifier)
        
        self.presenter.getData(callBack: self.getData(_:_:_:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.list = self.presenter.getFiltered(list: self.completeList,
                                               from: fromYear,
                                               to: toYear,
                                               rating: rating,
                                               name: search)
        self.tableView.reloadData()
    }

    func getData(_ list: [Movie]?, _ status: Bool, _ message: String) {
         if status {
            self.completeList = list ?? []
            self.list = self.completeList
            self.tableView.reloadData()
        } else {
            print(message, self.description)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! ListTableViewCell

        let movie: Movie = list[indexPath.row]

        cell.titleLabel.text = movie.title
        cell.ratingLabel.text = movie.getRating()
        cell.rating = movie.rating ?? 0
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilterSegue" {
            let filter = segue.destination as! FilterViewController
            
            filter.years = self.presenter.getYears(on: self.completeList)
        }
    }
}
