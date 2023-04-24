
import Foundation

struct LocationResponse: Decodable {
    let results: [DenemeLocation]
}

struct DenemeLocation: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]

}
