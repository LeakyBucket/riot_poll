# RiotPoll

Given a player name, this will check that player's last 5 matches and return a list of all _other_ players in those matches. It will then monitor those players for completed matches for the next hour.

## Usage

You can launch this locally by running `iex -S mix` from the project root. In order to get information on a player simply call `RiotPoll.run/2` with the name of the player and a region.

That will return a list of all the other players in their last 5 matches and start the polling process.

## Knobs

You will need to provide your own RIOT API key. It is expected to be in a `RIOT_API_KEY` environment variable.

There are also a couple of configuation values you can set for a little control over the polling:

1. `poll_iterations` - This is the number of times a player's match history will be polled
2. `poll_interval_seconds` - This is the number of seconds between checks of a player's match history
