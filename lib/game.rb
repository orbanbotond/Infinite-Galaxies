module InfiniteGalaxies
  class Game
    include AggregateRoot

    CanNotPlaceTheSamePlanetTwiceOnBoard = Class.new(StandardError)

    class Planet
      def initialize(name)
        @name = name
        @orbiting_ships = []
      end

      def may_orbit?(empire)
        !orbiting?(empire)
      end

      def orbit(empire)
        raise TheEmpireCanOrbitJustOneShipsAroundTheSamePlanet.new(empire, name) unless may_orbit?(empire)

        orbiting_ships << empire
      end

      private

      def orbiting?(empire)
        orbiting_ships.include?(empire)
      end

      attr_reader :orbiting_ships, :name
    end

    class TheEmpireDoesNotHaveReadyToFlyShips < StandardError
      def initialize(empire_name)
        @empire_name = empire_name
      end

      def message
        "The '#{@empire_name}' does not have ready to fly ships."
      end
    end

    class TheEmpireCanOrbitJustOneShipsAroundTheSamePlanet < StandardError
      def initialize(empire_name, planet_name)
        @empire_name = empire_name
        @planet_name = planet_name
      end

      def message
        "The '#{@empire_name}' is already orbiting a ship around the planet: #{@planet_name}."
      end
    end

    def initialize(name)
      @name = name
    end

    def place_planet_on_board(planet_name)
      guard_against_placing_the_same_planet_twice(planet_name)

      event = Events::PlanetPlacedOnboard.new(data: { planet_name: planet_name })
      apply event 
    end

    def setup_empire(empire_name)
      event = Events::SetupEmpire.new(data: { empire_name: empire_name })
      apply event       
    end

    def orbit_ship(empire_name, planet_name)
      guard_if_empire_has_ready_to_fly_ships(empire_name)
      guard_if_empire_already_orbiting_around_the_planet(empire_name, planet_name)

      event = Events::OrbitShip.new(data: { planet_name: planet_name, empire_name: empire_name })
      apply event 
    end

    def empires
      @empires ||= {}
    end

    def planets_on_board
      @planets_on_board ||= {}
    end

    private
      def guard_if_empire_already_orbiting_around_the_planet(empire_name, planet_name)
        # This violates the tell don't ask principle
        raise TheEmpireCanOrbitJustOneShipsAroundTheSamePlanet.new(empire_name, planet_name) unless planets_on_board[planet_name].may_orbit?(empire_name)
      end

      def guard_against_placing_the_same_planet_twice(planet_name)
        raise CanNotPlaceTheSamePlanetTwiceOnBoard if planets_on_board.include?(planet_name)
      end

      def guard_if_empire_has_ready_to_fly_ships(empire_name)
        raise TheEmpireDoesNotHaveReadyToFlyShips.new(empire_name) unless empires[empire_name] > 0
      end

      on Events::PlanetPlacedOnboard do |event|
        planet_name = event.data[:planet_name]
        planets_on_board[planet_name] = Planet.new(planet_name)
      end

      on Events::SetupEmpire do |event|
        empires[event.data[:empire_name]] = 2 
      end

      on Events::OrbitShip do |event|
        empire_name = event.data[:empire_name]
        planet_name = event.data[:planet_name]

        empires[empire_name] -= 1
        planets_on_board[planet_name].orbit(empire_name)
      end
  end
end
