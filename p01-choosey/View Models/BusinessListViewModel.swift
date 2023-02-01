import Foundation
import SwiftUI

class BusinessListViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var radius: Int = 1
    
    @Published var businesses: [Business] = []
    @Published var highestRatedId: String? = nil
    
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var isLoading: Bool = false
  
    func getPlaces() {
        // MARK: Add logic to clear businesses array and return from function here
        
        /*
         This guard statement is basically saying "searchTerm must have a length greater than 0 to continue"
         if the condition searchTerm.count > 0 returns false, then the else clause will execute
         otherwise, the rest of the function can proceed, as searchTerm is not empty
         */
        guard searchTerm.count > 0 else {
            businesses.removeAll()
            return
        }
        
        YelpService.getBusinesses(term: searchTerm, radius: radius) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let businesses):
                    self.businesses = businesses
                     self.highestRatedId = self.getBestRestaurantId(businesses: businesses)
                case .failure(let error):
                    self.errorMessage = error.rawValue
                    self.showError = true
                }
            }
        }
    }
    
    // MARK: Write your function here
    func getBestRestaurantId(businesses: [Business]) -> String? {
        
        guard var bestBusiness = businesses.first else {
            return nil
        }
        
        for business in businesses {
            print(business)
            if business.rating > bestBusiness.rating {
                bestBusiness = business
            }
        }
        
        return bestBusiness.id
    }
    

}
