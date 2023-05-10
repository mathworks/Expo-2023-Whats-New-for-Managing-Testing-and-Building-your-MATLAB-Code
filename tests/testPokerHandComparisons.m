classdef testPokerHandComparisons < matlab.unittest.TestCase
%TESTPOKERHANDCOMPARISONS Tests the >, <, and ~= PokerHand comparison
%operations
    properties
        Deck = PokerDeck();
    end
    properties (TestParameter)
        handGreaterThan = struct( ...
            SingleVsSingle = {{["2D","4H","6S","8C","QC"],["2C","4D","6H","8S","10C"]}}, ...
            Pair = {{["2D","4H","6S","8S","8C"],["2C","4D","4S","10C","QD"]}}, ...
            TwoPair = {{["2D","2C","5H","8S","8C"],["4D","4H","6S","6C","AC"]}}, ...
            ThreeOfAKind = {{["2D","8D","8H","8S","10D"],["2C","4D","4H","4S","10C"]}}, ...
            StraightBottom = {{["2D","3H","4S","5C","6D"],["2C","3D","4H","5S","AC"]}}, ...
            StraightMiddle = {{["9C","10D","JH","QS","KC"],["8C","9D","10H","JS","QC"]}}, ...
            Flush = {{["2C","3C","5C","6C","JC"],["2H","4H","6H","8H","10H"]}}, ...
            FullHouse = {{["QC","QD","QH","2S","2C"],["JC","JD","JH","AS","AC"]}}, ...
            FourOfAKind = {{["AC","AD","AH","AS","2C"],["KC","KD","KH","KS","3C"]}}, ...
            StraightFlush = {{["9D","10D","JD","QD","KD"],["8C","9C","10C","JC","QC"]}});
    end

    methods (Test, ParameterCombination="sequential")
        function testCreatePokerHands(testCase,handGreaterThan)
            cards1 = testCase.Deck.getCardsByIdentifier(handGreaterThan{1});
            cards2 = testCase.Deck.getCardsByIdentifier(handGreaterThan{2});
            hand1 = PokerHand(cards1);
            hand2 = PokerHand(cards2);
            
            testCase.verifyNumElements(hand1>hand2,1);
            testCase.verifyGreaterThan(hand1,hand2);
            testCase.verifyLessThan(hand2,hand1);
            testCase.verifyNotEqual(hand1,hand2);
        end
    end

end