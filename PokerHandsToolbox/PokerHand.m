classdef PokerHand < handle
    %POKERHAND Create and identify poker hands
    %   Provides an easy way to represent and compare poker hands

    properties (SetAccess=private)
        Type = "Empty";
    end
    
    properties
        Cards
    end

    methods
        function obj = PokerHand(cards)
            %POKERHAND Creates a poker hand from a set of cards
            arguments
                cards = [];
            end

            if ~isempty(cards)
                obj.Cards = cards;
            end
        end

        function set.Cards(obj,cards)
            % Ensure that the right number of cards are set
            if ~isempty(cards)
                mustBeA(cards,"table");
                if height(cards) ~= 5
                    error("Value of ""Cards"" must be empty or a set of 5 cards.");
                end
                obj.Cards = sortrows(cards,["Value","Suit"],["descend","descend"]);
            else
                obj.Cards = [];
            end

            obj.determineHandType();
        end
    end

    methods (Access = private)
        function determineHandType(obj)
            %DETERMINEHANDTYPE Determines hand type

            % Exit early if "Empty"
            if height(obj.Cards) == 0
                obj.Type = "Empty";
                return;
            end

            % Get card stats
            maxCardValue = max(obj.Cards.Value);

            [numOfCardsFound,valueOfCards] = groupcounts(obj.Cards.Value);
            singleVals = valueOfCards(numOfCardsFound==1);
            pairVals = valueOfCards(numOfCardsFound==2);
            tripVals = valueOfCards(numOfCardsFound==3);
            quadVals = valueOfCards(numOfCardsFound==4);

            isStraightAceConsideredHigh = all(abs(diff(obj.Cards.Value)) == 1);
            isStraightAceConsideredLow = all(ismember([2,3,4,5,14],obj.Cards.Value));
            isStraight = isStraightAceConsideredHigh || isStraightAceConsideredLow;
            if isStraightAceConsideredLow
                maxCardValue = 5;
            end

            isFlush = all(obj.Cards.Suit(1) == obj.Cards.Suit);

            % Determine hand type by characteristics
            if isStraight && isFlush && maxCardValue == 14
                obj.Type = "RoyalFlush";

            elseif isStraight && isFlush
                obj.Type = "StraightFlush";

            elseif ~isempty(quadVals)
                obj.Type = "FourOfAKind";

            elseif ~isempty(tripVals) && ~isempty(pairVals)
                obj.Type = "FullHouse";

            elseif isFlush
                obj.Type = "Flush";

            elseif isStraight
                obj.Type = "Straight";

            elseif ~isempty(tripVals)
                obj.Type = "ThreeOfAKind";

            elseif numel(pairVals) == 2
                obj.Type = "TwoPair";

            elseif numel(pairVals) == 1
                obj.Type = "Pair";

            elseif numel(singleVals) == 5
                obj.Type = "Single";

            else
                obj.Type = "Invalid";
            end

        end
    end

    methods (Static)
        function obj = empty()
            obj = PokerHand();
            obj(:) = [];
        end
    end
end

