import UIKit

protocol Parkable {
    var plate: String { get }
}

struct Parking {
//    ¿ Por qué se define vehicles como un Set?
//    Porque un Set es más ligero que un arreglo ya que no tiene
//    en cuenta el orden de los elementos ni permite duplicados.
//    En este caso, además, resulta conveniente porque ayuda a
//    garantizar que nunca tendremos vehículos duplicados en nuestro
//    parqueadero.
    var vehicles: Set<Vehicle> = []
}

struct Vehicle: Parkable, Hashable {
    let plate: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}
