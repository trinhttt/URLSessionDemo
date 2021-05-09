//
//  ViewController.swift
//  NetworkingDemo
//
//  Created by Trinh Thai on 08/05/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager().send(request: GetMovieRequest(pageNum: 1)) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let err):
                print(err)
            }
        }
    }
}

