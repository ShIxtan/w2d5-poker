class Hand

  attr_accessor :cards, :best

  def initialize(cards = [])
    @cards = cards
    @best = []
  end

  def get_singles(card_set = cards)
    self.best = cards.map(&:to_val).sort
  end

  def add_cards(drawn_cards)
    @cards += drawn_cards
  end

  def toss(toss_cards)
    num_cards = toss_cards.length
    toss_cards.each do |card|
      cards.delete(card)
    end
    num_cards
  end

  def count
    cards.count
  end

  def calculate_hand
    hand_value = :single
    get_singles

    hand_value = :pair if is_pair?
    hand_value = :two_pair if is_two_pair?
    hand_value = :three_of if is_three_of?
    hand_value = :straight if is_straight?
    hand_value = :flush if is_flush?
    hand_value = :full_house if is_full_house?
    hand_value = :four_of if is_four_of?
    hand_value = :straight_flush if is_straight_flush?

    hand_value
  end

  def is_pair?
    pairs = get_card_counts.select { |value, count| count == 2 }

    pairs.sort_by {|v,c| Card.val(v)}.each do |value, count|
      count.times do
        best << Card.val(value)
      end
    end

    !pairs.empty?
  end

  def is_three_of?
    threes = get_card_counts.select { |value, count| count == 3 }

    threes.sort_by {|v,c| Card.val(v)}.each do |value, count|
      count.times do
        best << Card.val(value)
      end
    end

    !threes.empty?
  end

  def is_four_of?
    fours = get_card_counts.select { |value, count| count == 4 }

    fours.sort_by {|v,c| Card.val(v)}.each do |value, count|
      count.times do
        best << Card.val(value)
      end
    end

    !fours.empty?
  end

  def is_two_pair?
    get_card_counts.select { |k,v| v == 2 }.count == 2
  end

  def is_full_house?
    is_pair? && is_three_of?
  end

  def is_flush?
    if get_suit_counts.count == 1
      get_singles
      return true
    end
    false
  end

  def is_straight_flush?
    is_flush? && is_straight?
  end

  def is_straight?
    temp_cards = cards.map{ |i| i.to_val }.sort
    temp_cards[0...-1].each_index do |index|
      return false if temp_cards[index] != temp_cards[index + 1] - 1
    end
    get_singles
    true
  end

  def get_suit_counts
    counts = Hash.new(0)

    cards.each do |card|
      counts[card.suit] += 1
    end

    counts
  end

  def get_card_counts
    counts = Hash.new(0)

    cards.each do |card|
      counts[card.value] += 1
    end

    counts
  end

  def hand_value(hand)
    [:single,:pair,:two_pair,:three_of,:straight,
    :flush,:full_house,:four_of,:straight_flush].index(hand)
  end

  def beats?(other_hand)
    ours = calculate_hand
    theirs = other_hand.calculate_hand
    if hand_value(ours) == hand_value(theirs)
      handle_tie(other_hand)
    else
      hand_value(ours) > hand_value(theirs)
    end
  end

  def handle_tie(other_hand)
    (1..best.count).each do |i|
      next if best[-i] == other_hand.best[-i]
      return (best[-i] > other_hand.best[-i])
    end
  end

end
