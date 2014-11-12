# Schedulizer

Referee scheduling at its finest

## Scheduling Procedure

### Wide Mode
Similar to World Cup, refs are considered unavailable if their team plays before, during, or after the given timeslot. If this option is disabled, a ref is only considered unavailable if their team plays during the same timeslot. This is enabled by default.


### Priorities
To be considered available, a ref must not be playing during that round and they must not ref more than 3 games in a row. Refs are then selected for games based on a priority queue sorted by the following criteria (in this order):

* Pool
* Associated with a team?
* Stars


See below for explanations of the criteria.

### Pool
Whenever possible, a ref from a different pool as the participants of the game is chosen. If there are no non-pool options, the system falls back on the next criterion.

### Team association
As free agents, unassociated referees can fill any gaps. Therefore, the system prioritizes using associated refs so they can be used while they're available. 

### Stars
Ideally, all refs are IRDP certified and the system simply ranks them according to their star rating.

In the event that the IRDP system doesn't have enough information to rank all participating refs (as is the current case with Australia), starred refs will be prioritized (in order) above non-starred refs and all others will be sorted randomly.

## Examples
	Game 1  
	Pool B  
	Team A vs Team B  
	Available refs: [Annie (pool A)(5 stars), Bernie (pool B)(10 stars), Charlie(pool A)(3 stars)]
	
	Annie is selected because she is the highest ranked opposite pool ref.
	
	------

	Game 2 
	Pool A
	Team C vs Team D
	Available refs: [David (pool A)(8 stars), Evelyn (pool A)(7 stars), Frank(pool A)(1 stars)]
	
	David is selected because he is the highest ranked ref and there are no available refs in the opposite pool.
	
	
	
<!-- ## Spec -->
<!-- * It doesn't have to be a perfect grid- just leave a round smaller if there are fewer games.  -->
<!-- * Reads from files! include stuff about that.  -->