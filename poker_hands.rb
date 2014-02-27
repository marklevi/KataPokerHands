class Game
  def initialize white_hand, black_hand
    @white_hand = Hand.new(white_hand)
    @black_hand = Hand.new(black_hand)
  end

  def winner
    compare_score
  end

  private

  def compare_score
    if @white_hand.score > @black_hand.score
      "white wins: #{@white_hand.best_hand}"
    elsif @white_hand.score < @black_hand.score
      "black wins: #{@black_hand.best_hand}"
    else
      compare_high_cards
    end
  end

  def compare_high_cards
    @white_hand.high_cards.each_index do |idx|
      if @white_hand.high_cards[idx] > @black_hand.high_cards[idx]
        return "white wins: #{@white_hand.best_hand} - #{@white_hand.high_cards[idx]}"
      elsif @white_hand.high_cards[idx] < @black_hand.high_cards[idx]
        return "black wins: #{@black_hand.best_hand} - #{@black_hand.high_cards[idx]}"
      else
        next
      end
    end
    "tie"
  end
end

class Hand
   RANKS = {
    straight_flush:  8,
    four_of_a_kind:  7,
    full_house:      6,
    flush:           5,
    straight:        4,
    three_of_a_kind: 3,
    two_pair:        2,
    pair:            1
  }.freeze


  attr_reader :cards, :rank
  def initialize hand
    @cards = hand.map { |card| Card.new(card) }
    @rank = find_rank #can distort multiples
  end

  def best_hand
    @rank.first
  end

  def score
    @rank.last
  end

  def high_cards
    @cards.map(&:value).sort.reverse
  end

  def multiples
    high_cards.inject(Hash.new(0)) { |h,v| h[v] += 1; h }.select { |k,v| v > 1 }
  end

  def pair?
    multiples.values.include? 2
  end

  def two_pair?
    multiples.values.count(2) == 2
  end

  def three_of_a_kind?
    multiples.values.include? 3
  end

  def straight?
    return true if high_cards.include?(14) && (high_cards & [14,2,3,4,5]).length == 5
    (high_cards[0] - high_cards[4] == 4) && high_cards.uniq.length == 5
  end

  def flush?
    @cards.map(&:suit).uniq.length == 1
  end

  def full_house?
    pair? && three_of_a_kind?
  end

  def four_of_a_kind?
    multiples.values.include? 4
  end

  def straight_flush?
    straight? && flush?
  end

  private

  def find_rank
    RANKS.detect { |method, rank| send :"#{method}?" } || [:high_card, 0]
  end
end

class Card
  SPECIAL_VALUE = {
    "T" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }
  SUIT = {
    "H" => :heart,
    "D" => :diamond,
    "S" => :spade,
    "C" => :clubs
  }

  attr_reader :value, :suit
  def initialize card
    @value = SPECIAL_VALUE[card[0]] || card[0].to_i
    @suit = SUIT[card[1]]
  end
end


