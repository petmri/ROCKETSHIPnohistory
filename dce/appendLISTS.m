function sortedfullpath = appendLISTS(sortedfullpath, sortlist_current)


for i = 1:numel(sortlist_current)
    sortedfullpath{end+1} = sortlist_current{i};

end
