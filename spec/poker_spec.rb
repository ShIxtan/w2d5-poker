require 'rspec'
require 'poker'

describe Card do
  describe "#to_s" do
    it "returns string in proper format" do
      a = Card.new(:spades, :jack)

      expect(a.to_s).to eq("♠J")
    end
  end

  describe "#compare" do
    let(:a) { Card.new(:spades, :jack) }
    let(:b) { Card.new(:spades, :ten) }
    let(:c) { Card.new(:hearts, :jack) }

    it "returns -1 if other card is greater" do
      expect(b.compare(a)).to eq(-1)
    end

    it "returns 1 if other card is less" do
      expect(a.compare(b)).to eq(1)
    end

    it "returns 0 if other card is equal" do
      expect(c.compare(a)).to eq(0)
    end
  end
end

describe Deck do
  describe "init" do
    it "creates a deck of 52 cards" do
      a = Deck.new
      expect(a.cards.length).to eq(52)
    end
  end

  describe "#Draw" do
    it "removes cards from the deck" do
      subject.draw(3)
      expect(subject.cards.length).to eq(49)
    end

    it "returns an array of cards" do
      a = Deck.new
      hand = a.draw(3)
      expect(hand.length).to eq(3)
      expect(hand.first.class).to eq(Card)
    end
  end

  describe "#refill" do
    it "refills the deck" do
      a = Deck.new
      hand = a.draw(3)
      a.refill
      expect(a.cards.length).to eq(52)
    end
  end
end

describe Hand do
  describe "#add_cards" do
    it "adds cards to the hand" do
      cards = [Card.new(:diamonds, :seven)]
      subject.add_cards(cards)
      expect(subject.count).to eq(1)
    end
  end

  describe "#toss" do
    let(:a) { Card.new(:spades, :jack) }
    let(:b) { Card.new(:spades, :ten) }
    let(:c) { Card.new(:hearts, :jack) }

    it "removes cards from hand" do
      subject.add_cards([a,b,c])
      subject.toss([a,c])

      expect(subject.count).to eq(1)
    end

    it "returns number of cards tossed" do
      subject.add_cards([a,b,c])
      expect(subject.toss([a,c])).to eq(2)
    end
  end

  describe "#calculate_hand" do
    let(:a) { Card.new(:spades, :jack) }
    let(:b) { Card.new(:spades, :ten) }
    let(:c) { Card.new(:hearts, :jack) }
    let(:d) { Card.new(:clubs, :ten) }
    let(:e) { Card.new(:diamonds, :jack) }
    let(:f) { Card.new(:clubs, :jack) }
    let(:g) { Card.new(:spades, :queen) }
    let(:h) { Card.new(:spades, :king) }
    let(:i) { Card.new(:spades, :nine) }
    let(:j) { Card.new(:spades, :five) }

    it "returns a pair if a pair" do
      subject.add_cards([a,b,c,i,j])
      expect(subject.calculate_hand).to eq(:pair)
    end

    it "returns a single if a single" do
      subject.add_cards([a,d,j,i,h])
      expect(subject.calculate_hand).to eq(:single)
    end

    it "returns three_of" do
      subject.add_cards([a,c,e,b,j])
      expect(subject.calculate_hand).to eq(:three_of)
    end

    it "returns a four_of" do
      subject.add_cards([a,c,e,f,j])
      expect(subject.calculate_hand).to eq(:four_of)
    end

    it "returns two_pair" do
      subject.add_cards([a,b,c,d,j])
      expect(subject.calculate_hand).to eq(:two_pair)
    end

    it "returns full_house" do
      subject.add_cards([a,b,c,d,e])
      expect(subject.calculate_hand).to eq(:full_house)
    end

    it "returns straight" do
      subject.add_cards([g,h,i,f,d])
      expect(subject.calculate_hand).to eq(:straight)
    end

    it "returns straight_flush" do
      subject.add_cards([a,b,g,h,i])
      expect(subject.calculate_hand).to eq(:straight_flush)
    end

    it "returns flush" do
      subject.add_cards([a,j,g,h,i])
      expect(subject.calculate_hand).to eq(:flush)
    end
  end

  describe "beats?" do
    let(:a) { Card.new(:spades, :jack) }
    let(:b) { Card.new(:spades, :ten) }
    let(:c) { Card.new(:hearts, :jack) }
    let(:d) { Card.new(:clubs, :ten) }
    let(:e) { Card.new(:diamonds, :jack) }
    let(:f) { Card.new(:clubs, :jack) }
    let(:g) { Card.new(:spades, :queen) }
    let(:h) { Card.new(:spades, :king) }
    let(:i) { Card.new(:spades, :nine) }
    let(:j) { Card.new(:spades, :five) }
    let(:k) { Card.new(:clubs, :eight) }
    let(:l) { Card.new(:spades, :eight) }
    let(:other_hand) { Hand.new }

    it "compares singles" do
      other_hand.add_cards([a,d,j,i,h])
      subject.add_cards([f,g,k,i,j])

      expect(subject.beats?(other_hand)).to eq(false)
      expect(other_hand.beats?(subject)).to eq(true)
    end

    it "compares hands good" do
      other_hand.add_cards([a,d,j,i,h])
      subject.add_cards([f,g,k,i,a])

      expect(subject.beats?(other_hand)).to eq(true)
      expect(other_hand.beats?(subject)).to eq(false)
    end

    it "compares tied two-pairs" do
      other_hand.add_cards([a,b,c,d,h])
      subject.add_cards([a,b,c,d,k])

      expect(subject.beats?(other_hand)).to eq(false)
      expect(other_hand.beats?(subject)).to eq(true)
    end

    it "compares two_pairs" do
      other_hand.add_cards([a,b,c,d,j])
      subject.add_cards([a,l,c,d,k])

      expect(subject.beats?(other_hand)).to eq(false)
      expect(other_hand.beats?(subject)).to eq(true)
    end
  end

end
