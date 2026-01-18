local wordList = require 'Dict.wordList'
require("Dict.trienode")

dictionary = {
	-- Trie object for optimal word checking
	trie = Trie:new(),
	-- Registers every word in word list to trie
	init = function()
		for i, word in ipairs(wordList) do
			dictionary.trie:addWord(word)
		end
	end,
	-- Check is word is valid in trie
	isWord = function(word)
		return dictionary.trie:isWord(word)
	end
}

return dictionary