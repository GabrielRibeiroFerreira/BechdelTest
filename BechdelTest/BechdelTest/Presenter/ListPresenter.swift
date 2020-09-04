//
//  ListPresenter.swift
//  BechdelTest
//
//  Created by Gabriel Ferreira on 03/09/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation
import HTMLString

class ListPresenter {
    typealias DataListCallBack = (_ dataList: [Movie]?, _ status: Bool, _ message: String) -> Void
    typealias ImageCallBack = (_ imageData: Data?, _ status: Bool, _ message: String) -> Void
    
    var service : ServiceProtocol!
    var method: String = "getAllMovies"
    let defaults: UserDefaults = UserDefaults.standard
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    init() {
        self.service = Service()
    }
    
    func getFiltered(list: [Movie], from: Int?, to: Int?, rating: Int?, name: String?) -> [Movie] {
        var movies: [Movie] = self.getInYears(from: from, to: to, on: list)
        movies = self.getBy(rating: rating, on: movies)
        movies = self.getBy(name: name, on: movies)
        
        return movies
    }
    
    func getInYears(from: Int?, to: Int?, on list: [Movie]) -> [Movie] {
        var movies: [Movie] = list
        
        if let f = from {
            while movies.first?.year == nil { movies.removeFirst() }
            
            while !movies.isEmpty {
                if let year = movies.first?.year {
                    if year < f {
                        movies.removeFirst()
                    } else {
                        break
                    }
                }
            }
        }
        
        if let t = to {
            while movies.last?.year == nil { movies.removeLast() }
            
            while !movies.isEmpty {
                if let year = movies.last?.year {
                    if year > t {
                        movies.removeLast()
                    } else {
                        break
                    }
                }
            }
        }
        
        return movies
    }
    
    func getBy(rating: Int?, on list: [Movie]) -> [Movie] {
        var movies: [Movie] = list
        
        var remove: [Int] = []
        
        if let r = rating {
            for i in 0..<movies.count {
                if let rating = movies[i].rating {
                    if rating != r  {
                        remove.insert(i, at: 0)
                    }
                }
            }
        }
        
        for i in remove {
            movies.remove(at: i)
        }
        
        return movies
    }
    
    func getBy(name: String?, on list: [Movie]) -> [Movie] {
        var movies: [Movie] = list
        
        var remove: [Int] = []
        
        if let n = name?.lowercased() {
            for i in 0..<movies.count {
                if let title = movies[i].title?.lowercased() {
                    if !title.contains(n) {
                        remove.insert(i, at: 0)
                    }
                }
            }
        }
        
        for i in remove {
            movies.remove(at: i)
        }
        
        return movies
    }
    
    func getYears(on list: [Movie]) -> [Int] {
        var years: [Int] = []
        
        for movie in list {
            if let year = movie.year {
                if !years.contains(year) {
                    years.append(year)
                }
            }
        }
        
        return years
    }
    
    //get list from cache or service
    func getData(callBack: @escaping DataListCallBack) {
        //generate a key to try to get from cache
        let key = String(self.method)
        
        //try to get the list from cache or try to get from service
        if let dataList = self.getDataFromCache(key: key) {
            callBack(dataList, true, "")
        } else {
            self.getDataFromService(callBack: callBack)
        }
    }
    
    //get data from cache with a key and a type
    func getDataFromCache(key: String) -> [Movie]? {
        //list of Movies
        var dataList: [Movie]? = nil
        
        //get from cache
        guard let movies = Cache.listCache.object(forKey: key as NSString) else { return nil }
        guard let list = movies.list else { return nil }
        dataList = list
        
        //return list
        return dataList
    }
    
    //get data from service with a url and a type
    func getDataFromService(callBack: @escaping DataListCallBack){
        do {
            let parameters = [:] as [String : Any]
            try service.getData(from: apiURL + self.method,
                                parameters: parameters,
                                callBack: { [weak self] (serviceData, status, message) in
                if status {
                    guard let data = serviceData else { return }
                    do {
                        print(message)
                        guard let self = self else {return}
                        let dataList: [Movie] = try JSONDecoder().decode([Movie].self, from: data)
                        var list: [Movie] = dataList.sorted(by: {
                            guard let year0 = $0.year, let year1 = $1.year else { return false }
                            return year0 < year1
                        })
                        
                        list = self.correctTitleFrom(list: list)
                        
                        let movies = ListMovie()
                        movies.list = list
                        
                        let key = String(self.method)
                        Cache.listCache.setObject(movies, forKey: NSString(string: key))

                        let date = Date()
                        let formatter = DateFormatter()
                        
                        formatter.dateFormat = "dd.MM.yyyy"
                        let current = formatter.string(from: date)
                        
                        self.defaults.setValue(data, forKey: self.method + current)
                        
                        callBack(list, true, "")
                    } catch {
                        print(error)
                    }
                } else {
                    print(message, self.debugDescription)
                    callBack(nil, false, message)
                }
            })
        }catch ConnectErrors.receivedFailure{
            callBack(nil, false, "Lack of internet connection")
        }catch{
            callBack(nil, false, error.localizedDescription)
        }
    }
    
    func correctTitleFrom(list: [Movie]) -> [Movie] {
        for movie in list {
            movie.title = movie.title?.removingHTMLEntities
        }
        
        return list
    }
}
