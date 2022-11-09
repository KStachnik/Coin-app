import Foundation

protocol CoinDelegate {
    func didUpdateCurrency(price: String, currency: String)
    func didFailWithError(error: Error)
}
