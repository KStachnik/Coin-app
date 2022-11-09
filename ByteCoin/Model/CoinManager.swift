import Foundation

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "98387677-05E0-4A2D-BE9F-73D78698657F"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinDelegate?
    
    func getCoinPrice(for currency: String) {
        let currencyUrl = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: currencyUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return //exit the function
                }
                
                if let safeData = data {
                    if let price = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", price)
                        delegate?.didUpdateCurrency(price: priceString, currency: currency)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            
            return rate
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
            
    }

}
