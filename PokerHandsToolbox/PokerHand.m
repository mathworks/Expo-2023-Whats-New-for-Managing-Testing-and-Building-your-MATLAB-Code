classdef PokerHand < handle
    %POKERHAND Create and identify poker hands
    %   Provides an easy way to represent and compare poker hands

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
        end
    end

    methods (Static)
        function obj = empty()
            obj = PokerHand();
            obj(:) = [];
        end
    end
end

