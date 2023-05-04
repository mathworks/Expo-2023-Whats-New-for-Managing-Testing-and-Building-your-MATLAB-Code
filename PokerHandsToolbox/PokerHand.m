classdef PokerHand < handle
    %POKERHAND Create and identify poker hands
    %   Provides an easy way to represent and compare poker hands

    properties (SetAccess=private)
        Type = "Empty";
        Symbols = "[]";
    end
    
    properties
        Cards
    end

    properties (Access=private)
        Strength = 0;
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

            obj.determineHandTypeAndStrength();
        end

        function handIsGreater = gt(obj,otherHand)
            handIsGreater = obj.Strength > otherHand.Strength;
        end
        function handIsGreaterOrEqual = ge(obj,otherHand)
            handIsGreaterOrEqual = obj.Strength >= otherHand.Strength;
        end
        function handIsLesser = lt(obj,otherHand)
            handIsLesser = obj.Strength < otherHand.Strength;
        end
        function handIsLesserOrEqual = le(obj,otherHand)
            handIsLesserOrEqual = obj.Strength <= otherHand.Strength;
        end
        function handIsEqual = eq(obj,otherHand)
            handIsEqual = obj.Strength == otherHand.Strength;
        end
        function comparisonMessage = compareHands(obj,otherHand)
            if obj == otherHand
                comparisonMessage = "Hands are equal in strength";
            elseif obj > otherHand
                comparisonMessage = "First hand beats second hand";
            else
                comparisonMessage = "Second hand beats first hand";
            end
        end
    end

    methods (Access = private)
        function determineHandTypeAndStrength(obj)
            %DETERMINEHANDTYPEANDSTRENGTH Determines hand type and strength
            %of hand using a points-based strength system
            % 
            % Points:
            %   -- Invalid       = 0 points
            %   -- Single        = 100 + (value of highest card)
            %   -- Pair          = 200 + (value of pair)
            %   -- TwoPair       = 250 + (value of highest pair) + (value of lower pair)/100
            %   -- ThreeOfAKind  = 300 + (value of three of a kind)
            %   -- Straight      = 400 + (value of highest card in straight)
            %   -- Flush         = 500 + (value of highest card)
            %   -- FullHouse     = 600 + (value of three of a kind)
            %   -- FourOfAKind   = 700 + (value of four of a kind)
            %   -- StraightFlush = 800 + (value of highest card)
            %   -- RoyalFlush    = same as StraightFlush

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
                [~,sortInd] = sort(obj.Cards.Value,"ascend");
                cardSymbols = obj.Cards.Symbol(sortInd);
                obj.Strength = 800 + maxCardValue;

            elseif isStraight && isFlush
                obj.Type = "StraightFlush";
                [~,sortInd] = sort(obj.Cards.Value,"ascend");
                cardSymbols = obj.Cards.Symbol(sortInd);
                obj.Strength = 800 + maxCardValue;

            elseif ~isempty(quadVals)
                obj.Type = "FourOfAKind";
                fourOfAKindInd = obj.Cards.Value == quadVals;
                cardSymbols = [obj.Cards.Symbol(fourOfAKindInd);obj.Cards.Symbol(~fourOfAKindInd)];
                obj.Strength = 700 + quadVals;

            elseif ~isempty(tripVals) && ~isempty(pairVals)
                obj.Type = "FullHouse";
                tripInd = obj.Cards.Value == tripVals;
                pairInd = obj.Cards.Value == pairVals;
                cardSymbols = [obj.Cards.Symbol(tripInd);obj.Cards.Symbol(pairInd)];
                obj.Strength = 600 + tripVals;

            elseif isFlush
                obj.Type = "Flush";
                [~,sortInd] = sort(obj.Cards.Value,"ascend");
                cardSymbols = obj.Cards.Symbol(sortInd);
                obj.Strength = 500 + maxCardValue;

            elseif isStraight
                obj.Type = "Straight";
                [~,sortInd] = sort(obj.Cards.Value,"ascend");
                cardSymbols = obj.Cards.Symbol(sortInd);
                obj.Strength = 400 + maxCardValue;

            elseif ~isempty(tripVals)
                obj.Type = "ThreeOfAKind";
                tripInd = obj.Cards.Value == tripVals;
                cardSymbols = [obj.Cards.Symbol(tripInd);obj.Cards.Symbol(~tripInd)];
                obj.Strength = 300 + tripVals + sum(obj.Cards.Value(~tripInd)./[100;10000]);

            elseif numel(pairVals) == 2
                obj.Type = "TwoPair";
                pairInd = ismember(obj.Cards.Value,pairVals);
                cardSymbols = [sort(obj.Cards.Symbol(pairInd),"descend");obj.Cards.Symbol(~pairInd)];
                obj.Strength = 250 + max(pairVals) + min(pairVals)/100 + obj.Cards.Value(~pairInd)/10000;

            elseif numel(pairVals) == 1
                obj.Type = "Pair";
                pairInd = obj.Cards.Value == pairVals;
                cardSymbols = [obj.Cards.Symbol(pairInd);obj.Cards.Symbol(~pairInd)];
                obj.Strength = 200 + pairVals + sum(obj.Cards.Value(~pairInd)./[10000;1000000;100000000]);

            elseif numel(singleVals) == 5
                obj.Type = "Single";
                [~,sortInd] = sort(obj.Cards.Value,"ascend");
                cardSymbols = obj.Cards.Symbol(sortInd);
                obj.Strength = 100 + sum(obj.Cards.Value./[1,100,10000,1000000,100000000]);

            else
                obj.Type = "Invalid";
                cardSymbols = [];
                obj.Strength = 0;
            end

            % Create symbol string representing the hand
            obj.Symbols = obj.createSymbolString(cardSymbols);

        end

        function symbolStr = createSymbolString(obj,cardSymbols)
            arguments
                obj
                cardSymbols = obj.Cards.Symbol;
            end

            if ismember(obj.Type,["Empty","Invalid"])
                symbolStr = "[]";
            else
                symbolStr = "[" + join(cardSymbols,"][") + "]";
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

