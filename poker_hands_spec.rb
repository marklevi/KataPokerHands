require_relative 'poker_hands.rb'

describe Game do
  context "#winner" do
    it "should return white_hand as the winner which has a three_of_a_kind" do
      white_hand = %w(8H 8C 8D QS KD) ## three of kind
      black_hand = %w(8H 3D 8D KS KD) ## two-pair
      game = Game.new(white_hand, black_hand)
      expect(game.winner).to eq("white wins: three_of_a_kind")
    end

    it 'should return black_hand to be the winner with a high ace' do
      white_hand = %w(8H 3D 8D KS KD)
      black_hand = %w(8H 4H 8D AS AD)
      game = Game.new(white_hand, black_hand)
      expect(game.winner).to eq("black wins: two_pair - 14")
    end

    it 'return white as winner' do
      white_hand =  %w(2C 3H 4S 8C AH)
      black_hand =  %w(2H 3D 5S 9C KD)
      game = Game.new(white_hand, black_hand)
      expect(game.winner).to eq("white wins: high_card - 14")
    end

    it 'return black as winner' do
      white_hand = %w(2C 3H 4S 8C KH)
      black_hand = %w(2H 3D 5S 9C KD)
      game = Game.new(white_hand, black_hand)
      expect(game.winner).to eq("black wins: high_card - 9")
    end

    it 'is a tie' do
      white_hand =  %w(2D 3H 5C 9S KH)
      black_hand =  %w(2H 3D 5S 9C KD)
      game = Game.new(white_hand, black_hand)
      expect(game.winner).to eq("tie")
    end
  end
end

describe Hand do
  let(:pair_hand) { Hand.new(%w(2H 3D 8D KS KD)) }
  let(:two_pair_hand) { Hand.new(%w(8H 3D 8D KS KD)) }
  let(:three_of_a_kind_hand) { Hand.new(%w(8H 8C 8D QS KD)) }
  let(:straight_hand) { Hand.new(%w(AH 2C 3D 4S 5D)) }
  let(:flush_hand) { Hand.new(%w(AS 2S 4S 8S KS)) }
  let(:full_house_hand) { Hand.new(%w(8H 8C 8D KS KD)) }
  let(:four_of_a_kind_hand) { Hand.new(%w(8H 8C 8D 8S KD)) }
  let(:straight_flush_hand) { Hand.new(%w(2C 3C 4C 5C 6C)) }

  context "on initialization" do
    it "creates 5 cards" do
      hand = Hand.new(%w(2H 3D 5S 9C KD))
      hand.cards.each do |card|
        expect(card).to be_a Card
      end
    end
  end

  context "#high_cards" do
    let(:hand) { Hand.new(%w(2H 3D 5S 9C KD)) }
    let(:hand2) { Hand.new(%w(2C 3H 4S 8C AH)) }

    it "returns the set of cards ordered from highest to lowest in value" do
      expect(hand.high_cards).to eq [13, 9, 5, 3, 2]
      expect(hand2.high_cards).to eq [14, 8, 4, 3, 2]
    end
  end

  context "#multiples" do
    it 'returns card values for a pair' do
      expect(pair_hand.multiples).to eq({ 13 => 2 })
    end

    it 'returns card values for two-pair' do
      expect(two_pair_hand.multiples).to eq({ 13 => 2, 8 => 2})
    end

    it 'return card values for three of a kind' do
      expect(three_of_a_kind_hand.multiples).to eq({ 8 => 3 })
    end

    it 'returns card values for full-house' do
      expect(full_house_hand.multiples).to eq({ 13 => 2, 8 => 3 })
    end

    it 'returns card values for four-of-a-kind' do
      expect(four_of_a_kind_hand.multiples).to eq({ 8 => 4 })
    end
  end

  context "#pair?" do
    it 'returns true if it is a pair' do
      expect(pair_hand.pair?).to be(true)
    end
  end

  context '#two-pair?' do
    it 'returns true if it is a pair' do
      expect(two_pair_hand.two_pair?).to eq(true)
    end
  end

  context '#three of a kind?' do
    it 'returns true if it is three of a kind' do
      expect(three_of_a_kind_hand.three_of_a_kind?).to eq(true)
    end
  end

  context '#straight?' do
    it 'returns true if it is striaight' do
      expect(straight_hand.straight?).to eq(true)
    end

    it 'returns false if it is an improper striaght' do
      hand = Hand.new(%w(JD QS KD AC 2S))
      expect(hand.straight?).to eq(false)
    end

    it 'returns false if it isnt a straight' do
      expect(pair_hand.straight?).to eq(false)
    end
  end

  context 'flush?' do
    it 'returns true if it is a flush' do
      expect(flush_hand.flush?).to eq(true)
    end
  end

  context '#full-house?' do
    it 'returns true if it is a full-house' do
      expect(full_house_hand.full_house?).to eq(true)
    end
  end

  context '#four-of-a-kind?' do
    it 'returns true if it is four of a kind' do
      expect(four_of_a_kind_hand.four_of_a_kind?).to eq(true)
    end
  end

  context '#straight_flush?' do
    it 'returns true if it is a straight flush' do
      expect(straight_flush_hand.straight_flush?).to eq(true)
    end
  end

  context 'ranking' do
    it 'should have a score of 1 and type pair' do
      expect(pair_hand.score).to eq(1)
      expect(pair_hand.best_hand).to eq(:pair)
    end

    it 'should have a score of 2 and type two_pair' do
      expect(two_pair_hand.score).to eq(2)
      expect(two_pair_hand.best_hand).to eq(:two_pair)
    end

    it 'should have a score of 3 and a type three_pair' do
      expect(three_of_a_kind_hand.score).to eq(3)
      expect(three_of_a_kind_hand.best_hand).to eq(:three_of_a_kind)
    end

    it 'should have a score of 4 and type straight' do
      expect(straight_hand.score).to eq(4)
      expect(straight_hand.best_hand).to eq(:straight)
    end

    it 'should have a score of 5 and type flush' do
      expect(flush_hand.score).to eq(5)
      expect(flush_hand.best_hand).to eq(:flush)
    end

    it 'should have a score of 6 and type full_house' do
      expect(full_house_hand.score).to eq(6)
      expect(full_house_hand.best_hand).to eq(:full_house)
    end

    it 'should have a score of 7 and type four_of_a_kind' do
      expect(four_of_a_kind_hand.score).to eq(7)
      expect(four_of_a_kind_hand.best_hand).to eq(:four_of_a_kind)
    end

    it 'should have a score of 8 and type straight_flush' do
      expect(straight_flush_hand.score).to eq(8)
      expect(straight_flush_hand.best_hand).to eq(:straight_flush)
    end
  end
end

describe Card do
  before do
    @card = Card.new("2H")
    @card2 = Card.new("5D")
    @special_card = Card.new("KC")
    @special_card2 = Card.new("TS")
  end
  context "on initialization" do
    it "sets the proper value on the number card" do
      expect(@card.value).to eq(2)
      expect(@card2.value).to eq(5)
    end

    it "sets the proper value on the number card" do
      expect(@special_card.value).to eq(13)
      expect(@special_card2.value).to eq(10)
    end

    it "sets the suits properly" do
      expect(@card.suit).to eq(:heart)
      expect(@card2.suit).to eq(:diamond)
      expect(@special_card.suit).to eq(:clubs)
      expect(@special_card2.suit).to eq(:spade)
    end
  end
end