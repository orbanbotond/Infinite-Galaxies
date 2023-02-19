require_relative './spec_helper'

RSpec.describe InfiniteGalaxies::Game do
  include InfiniteGalaxies::TestPlumbing

  describe 'placing planets onboard' do
    let(:game_name) { "New Game" }
    let(:game) { described_class.new(game_name) }

    it 'publishes the PlanetPlacedOnboard event' do
      game.place_planet_on_board("Mars")

      expect(game.unpublished_events.map(&:data)).to eq([
          InfiniteGalaxies::Events::PlanetPlacedOnboard.new(
            data: { planet_name: "Mars" }
          )
        ].map(&:data))
    end

    context 'when placing the same planet twice' do
      it 'publishes the PlanetPlacedOnboard event' do
        game.place_planet_on_board("Mars")
        expect do
          game.place_planet_on_board("Mars")
        end.to raise_error(InfiniteGalaxies::Game::CanNotPlaceTheSamePlanetTwiceOnBoard)
      end
    end
  end

  # describe 'shuffle dices' do
  # end

  describe 'orbit ship' do
    # /' The empire should have a ready to fly ship in its galaxy '/
    # /' An empire can not orbit two ships around the same planet '/

  end
end
