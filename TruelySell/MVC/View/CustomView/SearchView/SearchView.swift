//
//  SearchView.swift
//  SerachBarSample
//
//  Created by Leo Chelliah on 15/05/18.
//  Copyright © 2018 Leo Chelliah. All rights reserved.
//

import UIKit

public protocol SearchViewControllerDelegate {
    func didTapOnSearch(searchText:String)
}

class SearchView: UIView,UISearchBarDelegate {

    @IBOutlet var contentView:UIView!
    @IBOutlet var advancedSearchBtn:UIButton!
    @IBOutlet var backBtn:UIButton!
    @IBOutlet var searchContainerView:UIView!

    @IBOutlet var searchBar:UISearchBar!
    
    var delegate: SearchViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    private func commoninit() {
        
        Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
    @IBAction func didTapOnAdvSearch(_ sender: Any) {
        
    }
    
    //MARK: - Search bar methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text, text.count > 0 {
            if let delegate = self.delegate {
                delegate.didTapOnSearch(searchText: text)
            }
        }
    }
}
