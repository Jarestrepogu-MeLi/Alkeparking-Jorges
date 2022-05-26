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
    
    let maxSlots = 20
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish:
                                 (Bool) -> Void) {
        
        guard vehicles.count <= maxSlots - 1 else {
            onFinish(false)
            return
        }

        for v in vehicles {
            if vehicle.plate == v.plate {
                onFinish(false)
                return
            }
        }
        
        onFinish(true)
        vehicles.insert(vehicle)
    }
    
    mutating func checkOutVehicle(plate: String, onSuccess:(Int) -> (), onError:(Error) -> ()) {
    //La función tiene que ser mutating para poder modificar el struct.
        
        var currentVehicle: Vehicle
        
        for v in vehicles {
            if v.plate == plate {
                currentVehicle = v
                onSuccess(currentVehicle.type.rate) //Mensaje de prueba
                vehicles.remove(currentVehicle)
                return
            } else {
                print("No lo hubo")
            }
        }
        
        print("Me salí")
        
    }
    
    func calculateFee(vehicle: Vehicle, parkedTime: Int) -> Int {
        
        if parkedTime <= 120 {
            return vehicle.type.rate
        } else {
            let extraTime = Double(parkedTime) - 120
            let extraFee = Int(ceil((extraTime / 15) * 5)) //Hacemos este proceso para que el resultado sea redondeado hacia arriba.
            let totalFee = extraFee + vehicle.type.rate
            return totalFee
        }
        
    }
    
}



struct Vehicle: Parkable, Hashable {
    
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    var parkedTime: Int {
        Calendar.current.dateComponents([.second], from: checkInTime, to: Date()).second ?? 0
    }
    let discountCard: String?
    
    /* ¿Qué tipo de propiedad permite este comportamiento:
     lazy properties, computed properties o static properties?
     Se usa una propiedad computada ya que esta calcula el valor cuando es llamada*/
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
    
}

var alkeParking = Parking()
let vehicle1 = Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let vehicle2 = Vehicle(plate: "B222BBB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle3 = Vehicle(plate: "CC333CC", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle4 = Vehicle(plate: "DD444DD", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")
let vehicle5 = Vehicle(plate: "AA111BB", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_003")
let vehicle6 = Vehicle(plate: "B222CCC", type: VehicleType.moto, checkInTime: Date(), discountCard: "DISCOUNT_CARD_004")
let vehicle7 = Vehicle(plate: "CC333DD", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle8 = Vehicle(plate: "DD444EE", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_005")
let vehicle9 = Vehicle(plate: "AA111CC", type: VehicleType.car, checkInTime: Date(), discountCard: nil)
let vehicle10 = Vehicle(plate: "B222DDD", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle11 = Vehicle(plate: "CC333EE", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle12 = Vehicle(plate: "DD444GG", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_006")
let vehicle13 = Vehicle(plate: "AA111DD", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_007")
let vehicle14 = Vehicle(plate: "B222BCB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle15 = Vehicle(plate: "CC333XC", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle16 = Vehicle(plate: "DD444WD", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_008")
let vehicle17 = Vehicle(plate: "AA111HB", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_009")
let vehicle18 = Vehicle(plate: "B222CTC", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle19 = Vehicle(plate: "CC333KD", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle20 = Vehicle(plate: "DD444QE", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_010")
let vehicle21 = Vehicle(plate: "AA111AC", type: VehicleType.car, checkInTime: Date(), discountCard: nil)
let vehicle22 = Vehicle(plate: "B222DMD", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let vehicle23 = Vehicle(plate: "CC333NE", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let vehicle24 = Vehicle(plate: "DD444RG", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_011")
let vehicle25 = Vehicle(plate: "AA111YD", type: VehicleType.car, checkInTime: Date(), discountCard: nil)

let vehicleArray: [Vehicle] = [vehicle1, vehicle2, vehicle3, vehicle4, vehicle5,
                               vehicle6, vehicle7, vehicle8, vehicle9, vehicle10,
                               vehicle11, vehicle12, vehicle13, vehicle14, vehicle15,
                               vehicle16, vehicle17, vehicle18, vehicle19, vehicle20,
                               vehicle21, vehicle22, vehicle23, vehicle24, vehicle25]

for v in vehicleArray {
    alkeParking.checkInVehicle(v) { check in
        check ? print("Todo bien mono, le queda bien cuidado :)") : print("No mono, acá no fue. Revise a la vuelta")
    }
}

//alkeParking.checkOutVehicle(plate: "AA111AA") { rate in
//    print(rate)
//} onError: { error in
//    print(error)
//}

print(alkeParking.calculateFee(vehicle: vehicle17, parkedTime: 193))



//alkeParking.vehicles.forEach({ vehicle in
//    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//        print(vehicle.parkedTime)
//    }
//})


