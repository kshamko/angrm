# Anagram Detection Tool

* load words from file "words" (attached)
* prompt user for any word to enter
* find and print all anagrams of entered word, ignoring upper/lower case
* loop to user prompt
* exit on "quit" word

Optimize code for lookup speed and for file loading speed when possible

## Build & Run

**rebar3** is required to run things. Verified on Erlang/OTP 21

```bash
$ make compile-all
$ make run
```
in Erlang shell run

```
1> idtang_prompt:anagram().
```
## Approach

* words from text file are being loaded into *map* datastructure where key is a hash and value is a word itself
* to search anagram by user input hash function is applied to the word provided, after that hash used to locate anagrams im map. So read operation has O(1) complexity
* words loaded from file by **idtang_loader** which uses set of workers running under simpe_one_for_one supervisor to generate key-value pairs. Words are sent to workers by batches of 20 items

## Known Issues
* App parameters like batch size and filepath are hardcoded.
* Lack of tests
* Fix dialyzer warnings