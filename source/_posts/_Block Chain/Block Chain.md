1. **Consensus Algorithm**
	- PoW - the hard methematical problem
		Miners must compete to solve a hard methematical problem determined by the network  difficulty level to add a new block. **The hard methematical problem ** : there is a target hash value determined by the network such as `000000000x`, miners would try to find a nonce appending to block data and the hash result would lesser than target hash value(such that starts with at least a specific number of zero). The target hash value will decrease over time so it were getting harder to mine a new block.
	- PoB(Proof of Burn)
		Miners send their coins to such addresses from where they cant be used. It is sent to a pulic verifiable address where it cannot be accessed and thus can not be used. The more coins miner burns the more they have the power to create blocks. When the coin is burnt its availability decreases leading to a potential increase in the value of the coin. PoB required very little power compared to PoW. But it may suffer from rich getting richer phenomena. In which those who are wealthy are getting wealthier by having more coins.
	- PoS(Proof of Stake)
		Miners invest in the coins by locking up some of their coins as a stake. Validators compete to validate the blocks by placing a bet on them. Based on the actual blocks added in the Blockchain, all the validators get a reward proportionate to their bets, and their stake increase accordingly. The more stake miners invest the more profit they get. It encourages long-term involvement in a project as a consumer is displaying a big commitment to the currency by a narrow profit in exchange for a long-term profit.
2. **Blockchain Structure**
- Block struct
	![[Pasted image 20230708100705.png]]
		- Header: block metadata
		- Prev block address: such that hash of previous block
		- Nonce: a random hexnumber found by miner which is the answer to PoW
		- Merkel Root: all transactions in the block are stored in a Merkel Tree. Merkel Root hash is convenient to Block Forking. 
- Candidate Block
	Candidate Block stands for blocks that have been already created but not verified yet. Any transaction in such state would be stored in a memory pool. 

- Block Fork - the longest chain mechanism, orphan
- Mining - how to add a new block
- 




