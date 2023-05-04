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

        function cards = getCardsByIdentifier(obj,ident)
            cardsInd = ismember(obj.UnshuffledCards.Identifier,ident);
            cards = obj.UnshuffledCards(cardsInd,:);
        end

        function hands = dealPokerHands(obj,numPlayers)
            %DEAL Deal 5-card poker hands to players (1 player by default)
            arguments
                obj
                numPlayers (1,1) double {mustBeGreaterThanOrEqual(numPlayers,0),mustBeInteger} = 1;
            end

            hands = PokerHand.empty();

            % Deal cards to each player
            for ii = numPlayers:-1:1
                startCardInd = ii;
                endCardInd = numPlayers*4 + ii;
                hands(ii) = PokerHand(obj.Cards(startCardInd:numPlayers:endCardInd,:));
            end

            % Remove dealt cards from shuffled cards
            obj.Cards(1:numPlayers*5,:) = [];
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

