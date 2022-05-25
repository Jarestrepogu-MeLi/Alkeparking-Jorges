import UIKit
import Foundation

protocol Parkable {
    var plate: String { get }
    var checkInTime: Date { get }
    var parkedTime: Int { get }
    var discountCard: String? { get }
    var type: VehicleType { get }
    /*¿Puede cambiar el tipo del vehículo en el tiempo?¿Debe definirse como variable o constante en Vehicle?
     No puede cambiar porque no tiene sentid para el objeto que el tipo pueda cambiar entonces debe ser constante.*/
}

enum VehicleType {
    case car
    case moto
    case miniBus
    case bus
    
    var rate: Int {
        /* ¿Qué elemento de control de flujos podría ser útil para determinar la tarifa de cada vehículo en la
         computed property : ciclo for, if o switch?
         Switch contempla de una vez todos los casos posibles dentrol del enum y es más limpio */
        switch self {
        case .car:
            return 20
        case .moto:
            return 15
        case .miniBus:
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
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    var parkedTime: Int {
        Calendar.current.dateComponents([.second], from: checkInTime, to: Date()).second ?? 0
    }
    /* ¿Qué tipo de propiedad permite este comportamiento:
     lazy properties, computed properties o static properties?
     Se usa una propiedad computada ya que esta calcula el valor cuando es llamada*/
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
        return 0
    }
}

var alkeParking = Parking()
let car = Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let moto = Vehicle(plate: "B222BBB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let miniBus = Vehicle(plate: "CC333CC", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let bus = Vehicle(plate: "DD444DD", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")
alkeParking.vehicles.insert(car)
alkeParking.vehicles.insert(moto)
alkeParking.vehicles.insert(miniBus)
alkeParking.vehicles.insert(bus)
alkeParking.vehicles.forEach({ vehicle in
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        print(vehicle.parkedTime)
    }
})


