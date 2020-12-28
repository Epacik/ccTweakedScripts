function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function string.startsWith(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

function string:startsWith(Start)
    return string.sub(self,1,string.len(Start)) == Start;
end