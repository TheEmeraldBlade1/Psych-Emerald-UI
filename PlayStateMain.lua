function goodNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then
         setProperty('health',getProperty('health')+0.009)
    end
end