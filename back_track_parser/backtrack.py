#!/usr/bin/env python

from copy import copy

class BackTrack(object):
    """Top-Down Depth First Parsing: backtrack"""
    def __init__(self, grammar, tokens):
        super(BackTrack, self).__init__()
        self.grammar = grammar # [(lhs, rhs), ...]
        self.tokens = tokens # [(nonterminals, ...), (terminals, ...)], assume that the first nonterminal is the start symbol

    def parse(self, string):
        string = self._scanning(string)
        self.seq = []
        sentential_form = [self.tokens[0][0]] # starting symbol
        flag = self._dfs(string, sentential_form)
        self.seq.reverse()
        return (flag, self.seq)

    def _dfs(self, string, sentential_form):
        """top-down depth first search

        """
        flag = False
        for index, production in enumerate(self.grammar):
            if production[0] == sentential_form[0]: # left-most derivation
                rst = self._is_valid(string, sentential_form, production)
                if rst[0]:
                    if not rst[1] and not rst[2]: # base case
                        flag = True
                    else:
                        flag = self._dfs(rst[1], rst[2])
                    if flag:
                        self.seq.append(index + 1) # reverse post order
                        # print "string: %s"%rst[1]
                        # print "sentential_form: %s"%rst[2]
                        # print "\n"
                        return flag
        return flag


    def _is_valid(self, string, sentential_form, production):
        """pattern matching

        """
        string_cp = copy(string)
        sentential_form_cp = copy(sentential_form)
        if sentential_form_cp:
            sentential_form_cp.pop(0) # remove the first symbol which is a nonterminal
        sentential_form_cp = production[1] + sentential_form_cp

        flag = False
        terminals = []
        for each in sentential_form_cp:
            if each in self.tokens[1]:
                if each is not 'epl':
                    terminals.append(each)
                else:
                    flag = True
            else:
                break
        if flag:
            sentential_form_cp.remove('epl')

        if terminals == string_cp[:len(terminals)]:
            sentential_form_cp = sentential_form_cp[len(terminals):]
            string_cp = string_cp[len(terminals):]
            if not string_cp and self._has_terminals(sentential_form_cp): # early stop
                return [False, [], []]
            elif not sentential_form_cp and string_cp: # early stop
                return [False, [], []]
            else:
                return [True, string_cp, sentential_form_cp]
        else:
            return [False, [], []]

    def _scanning(self, string):
        """toy scanning

        """
        return list(string)

    def _has_terminals(self, string):
        for each in string:
            if each in self.tokens[1]:
                return True
        return False

if __name__ == '__main__':
    grammar = [('S', ['a', 'S', 'b', 'S']), ('S', ['b', 'S', 'a', 'S']), ('S', ['epl'])]
    tokens = [('S'), ('a', 'b', 'epl')]
    string = "abab"
    back_track = BackTrack(grammar, tokens)
    rst = back_track.parse(string)
    print rst
