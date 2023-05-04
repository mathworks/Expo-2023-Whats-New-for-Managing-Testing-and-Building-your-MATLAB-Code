function stats = pokerHandStats(handType)
%POKERHANDSTATS Returns a table of poker hand statss

arguments
    handType string {mustBeScalarOrEmpty, ...
        mustBeMember(handType, ...
        ["RoyalFlush"; ...
        "StraightFlush"; ...
        "FourOfAKind"; ...
        "FullHouse"; ...
        "Flush"; ...
        "Straight"; ...
        "ThreeOfAKind"; ...
        "TwoPair"; ...
        "Pair"; ...
        "Single"])} = [];
end

% Get pre-computed table of statistics
stats = pokerHandStatsTable;

% Only return specific hand type stats on when requested
if ~isempty(handType)
    ismember(stats.HandType,handType);
    stats = stats(ans,:);

    % Using "ans" in your code can introduce unreliable behavior because
    % "ans" can be silently overwritten often. Replacing the rest of the
    % code in this "if" block with the code below will ensure more robust
    % code behavior.
    
    % ind = ismember(stats.HandType,handType);
    % stats = stats(ind,:);
end

end

