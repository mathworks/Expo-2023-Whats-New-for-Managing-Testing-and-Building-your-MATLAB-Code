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
                [~,sortInd] = sort(obj.Cards.Value,"ascend");
                cardSymbols = obj.Cards.Symbol(sortInd);

            elseif isStraight && isFlush
                obj.Type = "StraightFlush";
                [~,sortInd] = sort(obj.Cards.Value,"ascend");
                cardSymbols = obj.Cards.Symbol(sortInd);

            elseif ~isempty(quadVals)
                obj.Type = "FourOfAKind";
                fourOfAKindInd = obj.Cards.Value == quadVals;
                cardSymbols = [obj.Cards.Symbol(fourOfAKindInd);obj.Cards.Symbol(~fourOfAKindInd)];

            elseif ~isempty(tripVals) && ~isempty(pairVals)
                obj.Type = "FullHouse";
                tripInd = obj.Cards.Value == tripVals;
                pairInd = obj.Cards.Value == pairVals;
                cardSymbols = [obj.Cards.Symbol(tripInd);obj.Cards.Symbol(pairInd)];

            elseif isFlush
                obj.Type = "Flush";
                [~,sortInd] = sort(obj.Cards.Value,"ascend");
                cardSymbols = obj.Cards.Symbol(sortInd);

            elseif isStraight
                obj.Type = "Straight";
                [~,sortInd] = sort(obj.Cards.Value,"ascend");
                cardSymbols = obj.Cards.Symbol(sortInd);

            elseif ~isempty(tripVals)
                obj.Type = "ThreeOfAKind";
                tripInd = obj.Cards.Value == tripVals;
                cardSymbols = [obj.Cards.Symbol(tripInd);obj.Cards.Symbol(~tripInd)];

            elseif numel(pairVals) == 2
                obj.Type = "TwoPair";
                pairInd = ismember(obj.Cards.Value,pairVals);
                cardSymbols = [sort(obj.Cards.Symbol(pairInd),"descend");obj.Cards.Symbol(~pairInd)];

            elseif numel(pairVals) == 1
                obj.Type = "Pair";
                pairInd = obj.Cards.Value == pairVals;
                cardSymbols = [obj.Cards.Symbol(pairInd);obj.Cards.Symbol(~pairInd)];

            elseif numel(singleVals) == 5
                obj.Type = "Single";
                [~,sortInd] = sort(obj.Cards.Value,"ascend");
                cardSymbols = obj.Cards.Symbol(sortInd);

            else
                obj.Type = "Invalid";
                cardSymbols = [];
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

