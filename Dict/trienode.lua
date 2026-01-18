local class = require 'middleclass'

Trie = class('Trie')

function Trie:initialize()
	self.valid = false
	self.letters = {}
end

-- Registers word validity to the trie
function Trie:addWord(word)
	if #word < 1 then self.valid = true return end
	if #word > 7 then return end
	if not self.letters[word:sub(1,1)] then self.letters[word:sub(1,1)] = Trie:new() end
	self.letters[word:sub(1,1)]:addWord(word:sub(2))
end

-- Returns whether word has been registered on the trie
function Trie:isWord(word)
	word = string.upper(word)
	if #word < 1 then return self.valid end
	if not self.letters[word:sub(1,1)] then return false end
	return self.letters[word:sub(1,1)]:isWord(word:sub(2))
end