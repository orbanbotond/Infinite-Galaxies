require_relative './spec_helper'

RSpec.describe InfiniteGalaxies::Game do
  include InfiniteGalaxies::TestPlumbing

  let(:game_name) { "New Game" }
  let(:empire_black) { "Black" }
  let(:game) { described_class.new(game_name) }
  let(:mars) { "Mars" }
  let(:venus) { "Venus" }
  let(:jupiter) { "Jupiter" }
  let(:game_ready_to_play) do
    game = described_class.new(game_name)
    game.setup_empire( empire_black )
    game.place_planet_on_board( mars )
    game.place_planet_on_board( venus )
    game.place_planet_on_board( jupiter )
    game
  end

  describe 'placing planets onboard' do
    it 'publishes the PlanetPlacedOnboard event' do
      game.place_planet_on_board( mars )

      expect(game.unpublished_events.map(&:data)).to eq([
          InfiniteGalaxies::Events::PlanetPlacedOnboard.new(
            data: { planet_name: mars }
          )
        ].map(&:data))
    end

    context 'when placing the same planet twice' do
      it 'raises a CanNotPlaceTheSamePlanetTwiceOnBoard error' do
        game.place_planet_on_board( mars )
        expect do
          game.place_planet_on_board( mars )
        end.to raise_error(InfiniteGalaxies::Game::CanNotPlaceTheSamePlanetTwiceOnBoard)
      end
    end
  end

  # describe 'shuffle dices' do
  # end

  describe 'orbit ship' do
    context 'when there are available ships' do
      context "when the empire isn't orbiting a ship around the planet yet" do
        it 'published the OrbitShip event' do
          game_ready_to_play.orbit_ship( empire_black, mars)

          expect(game_ready_to_play.unpublished_events.map(&:data).last).to eq(
                { planet_name: mars, empire_name: empire_black } )
        end
      end

      context "when the empire is already orbiting a ship around the planet" do
        it 'raises a TheEmpireCanOrbitJustOneShipsAroundTheSamePlanet' do
          game_ready_to_play.orbit_ship( empire_black, mars)

          expect do
            game_ready_to_play.orbit_ship( empire_black, mars)
          end.to raise_error(InfiniteGalaxies::Game::TheEmpireCanOrbitJustOneShipsAroundTheSamePlanet)
        end
      end
    end

    context "when there aren't any ready to fly ships available for the empire" do
      it 'raises a TheEmpireDoesNotHaveReadyToFlyShips error' do
        game_ready_to_play.orbit_ship( empire_black, mars)
        game_ready_to_play.orbit_ship( empire_black, venus)

        expect do
          game_ready_to_play.orbit_ship( empire_black, jupiter)
        end.to raise_error(InfiniteGalaxies::Game::TheEmpireDoesNotHaveReadyToFlyShips)
      end
    end

    # /' The empire should have a ready to fly ship in its galaxy '/
    # /' An empire can not orbit two ships around the same planet '/
  end
end
