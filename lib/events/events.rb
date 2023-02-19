module InfiniteGalaxies
  module Events
    class PlanetPlacedOnboard < ::Infra::Event
      attribute :planet_name, Infra::Types::Strict::String
    end
  end
end
