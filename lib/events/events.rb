module InfiniteGalaxies
  module Events
    class PlanetPlacedOnboard < ::Infra::Event
      attribute :planet_name, Infra::Types::Strict::String
    end

    class SetupEmpire < ::Infra::Event
      attribute :empire_name, Infra::Types::Strict::String
    end

    class OrbitShip < ::Infra::Event
      attribute :empire_name, Infra::Types::Strict::String
      attribute :planet_name, Infra::Types::Strict::String
    end
  end
end
