Locales = {}

function _U(str, ...)
    if Locales[Config.Locale] ~= nil then
        if Locales[Config.Locale][str] ~= nil then
            return string.format(Locales[Config.Locale][str], ...)
        end
    end
    return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
end