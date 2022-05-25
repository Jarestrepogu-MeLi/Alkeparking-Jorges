import UIKit
import Foundation

protocol Parkable {
    var plate: String { get }
    var checkInTime: Date { get }
    var parkedTime: Int? { mutating get }
    var discountCard: String? { get }
    var type: VehicleType { get }
    /*¿Puede cambiar el tipo del vehículo en el tiempo?¿Debe definirse como variable o constante en Vehicle?
     No puede cambiar porque no tiene sentid para el objeto que el tipo pueda cambiar entonces debe ser constante.*/
}

enum VehicleType {
    case auto
    case moto
    case minibus
    case bus
    
    var rate: Int {
        /* ¿Qué elemento de control de flujos podría ser útil para determinar la tarifa de cada vehículo en la
         computed property : ciclo for, if o switch?
         Switch contempla de una vez todos los casos posibles dentrol del enum y es más limpio */
        switch self {
        case .auto:
            return 20
        case .moto:
            return 15
        case .minibus:
            return 25
        case .bus:
            return 30
        }
    }
}

struct Parking {
    /*    ¿Por qué se define vehicles como un Set?
     Porque un Set es más ligero que un arreglo ya que no tiene
     en cuenta el orden de los elementos ni permite duplicados.
     En este caso, además, resulta conveniente porque ayuda a
     garantizar que nunca tendremos vehículos duplicados en nuestro
     parqueadero. */
    var vehicles: Set<Vehicle> = []
}

struct Vehicle: Parkable, Hashable {

    let type: VehicleType
    let plate: String
    let checkInTime: Date
    var parkedTime: Int?
    /* ¿Qué tipo de propiedad permite este comportamiento:
     lazy properties, computed properties o static properties?
     Es la propiedad lazy ya que solo la necesitamos llamar para calcular la tarifa y solo es relevante en ese momento*/
    let discountCard: String?
    /* ¿Dónde deben agregarse las propiedades, en Parkable, Vehicle o en ambos?
        En ambos porque en el protocolo definimos el requisito y en la estructura satisfacemos el requisito
     
        La tarjeta de descuentos es opcional, es decir que un vehículo puede no tener una tarjeta y su valor será nil.
        ¿Qué tipo de dato de Swift permite tener este comportamiento?
        El string opcional
     */
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
    
    mutating func totalParkingTime() -> Int {
        
        return Calendar.current.dateComponents([.second], from: checkInTime, to: Date()).second ?? 0  //Segundos para probar. Recordar cambiar a minutos
        
    }
}

var vehiculo = Vehicle(type: .auto, plate: "abc", checkInTime: Date(),parkedTime: 0, discountCard: "dbhjsdfb")
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    print(vehiculo.totalParkingTime())
}


