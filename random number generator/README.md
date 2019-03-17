
# Hardware Random Number Generator
## Design Aspects
### Randomize within a range
- Normal LFSR randomize within the minimum and maximum of its bit width .
- Ex: 8–bit LFSR randomize between 0 and 255 . 
- There are 3 main approaches to modify LFSR to randomize within range .
#### 1.Lookup table mapping
- Advantages:
Very fast
- Disadvantages:
1.Need more memory
2.Need constant range

#### 2.Mod mapping
- Advantages:
simple
- Disadvantages:
May be computationally expensive

#### 3.Using multiple instances of different LFSRs
- The idea here is to calling multiple LFSRs and adding results from them.
- No change in LFSR it self , the output maximum is the maximum value of the bits .
- Example: range : 44 to 55 
- The difference =55-44=11
- Output=LFSR_3bits+LFSR_2bits+LFSR_1bits
- The problem is to get 3,2,1 from 11
- Or for example, to get 3,2,1,1 from 12


