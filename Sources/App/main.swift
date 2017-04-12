///
/// Deploying URL: https://aqueous-falls-99981.herokuapp.com/api/users
///


import Foundation
import Vapor
import HTTP
import VaporPostgreSQL


let drop = Droplet()


try setup(drop: drop)


drop.run()
