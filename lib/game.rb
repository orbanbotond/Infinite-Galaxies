module InfiniteGalaxies
  class Game
    include AggregateRoot

    CanNotPlaceTheSamePlanetTwiceOnBoard = Class.new(StandardError)

    def initialize(name)
      @name = name
    end

    def place_planet_on_board(planet_name)
      guard_against_placing_the_same_planet_twice(planet_name)

      event = Events::PlanetPlacedOnboard.new(data: { planet_name: planet_name })
      apply event 
    end

    def planets_on_board
      @planets_on_board ||= []
    end

    private
      def guard_against_placing_the_same_planet_twice(planet_name)
        raise CanNotPlaceTheSamePlanetTwiceOnBoard unless planets_on_board.none?{ |planet| planet == planet_name }
      end

      on Events::PlanetPlacedOnboard do |event|
        planets_on_board << event.data[:planet_name]
      end
  end
end
