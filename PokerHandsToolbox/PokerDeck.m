classdef PokerDeck < handle
%POKERDECK Creates a deck of cards (without jokers) containing both
%shuffled cards (Cards) and unshuffled cards (UnshuffledCards)

    properties
        Cards
        UnshuffledCards
    end

    methods
        function obj = PokerDeck(opts)
            %POKERDECK Creates a deck containing both shuffled cards (Cards) and
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
                numPlayers (1,1) double { ...
                    mustBeInteger, ...
                    mustBeGreaterThanOrEqual(numPlayers,0), ...
                    mustBeLessThanOrEqual(numPlayers,10)} = 1;
            end

            % Check if there aren't enough cards to deal, and tell the
            % player to shuffle again before dealing
            if height(obj.Cards) < numPlayers*5
                pluralStr = "";
                if numPlayers > 1
                    pluralStr = "s";
                end
                errMsg = [ ...
                    "Not enough cards in the deck to deal " + numPlayers + " poker hand" + pluralStr + "."; ...
                    "Please shuffle the deck before dealing the cards again."];
                error(join(errMsg,newline));
            end

            % Initialize an empty hand
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
            %INITIALIZEDECK Initializes a standard deck of cards without jokers
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
            %EMPTY Creates an empty PokerDeck object
            d = PokerDeck(ShuffleOnCreation=false);
            emptyCards = d.UnshuffledCards([],:);
        end
    end
end

