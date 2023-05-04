classdef PokerDeck < handle
    %DECK A deck of cards
    %   An easy way to work with a standard deck of cards (without jokers)

    properties
        Cards
        UnshuffledCards
    end

    methods
        function obj = PokerDeck(opts)
            %DECK Creates a deck containing both shuffled cards (Cards) and
            %unshuffled cards (UnshuffledCards)
            arguments
                opts.ShuffleOnCreation (1,1) logical = true;
            end

            obj.initializeDeck();
            if opts.ShuffleOnCreation
                obj.shuffle();
            end
        end

        function shuffle(obj)
            %SHUFFLE Shuffle UnshuffledCards -> Cards
            rng("shuffle");
            shuffleInd = randperm(height(obj.UnshuffledCards));
            obj.Cards = obj.UnshuffledCards(shuffleInd,:);
        end
    end

    methods (Access = private)
        function initializeDeck(obj)
            %INITIALIZEDECK Initializes a standard deck of cards without
            %jokers
            suits = ["Clubs","Diamonds","Hearts","Spades"];
            cardNames = [string(2:10),"Jack","Queen","King","Ace"];
            cardValues = 2:14;
            cardSymbols = [string(2:10),"J","Q","K","A"];

            suitsRep = reshape(repmat(suits,13,1),[],1);
            cardNamesRep = repmat(cardNames',4,1);
            cardValuesRep = repmat(cardValues',4,1);
            cardSymbolsRep = repmat(cardSymbols',4,1);
            cardIdentifiersRep = cardSymbolsRep + extract(suitsRep,regexpPattern("^."));

            obj.UnshuffledCards = table(cardNamesRep,suitsRep,cardValuesRep,cardSymbolsRep,cardIdentifiersRep, ...
                VariableNames = ["Name","Suit","Value","Symbol","Identifier"]);
            obj.UnshuffledCards = sortrows(obj.UnshuffledCards,["Suit","Value"],["descend","descend"]);
            obj.Cards = obj.UnshuffledCards;
        end
    end

    methods (Static)
        function emptyCards = empty()
            d = PokerDeck(ShuffleOnCreation=false);
            emptyCards = d.UnshuffledCards([],:);
        end
    end
end

