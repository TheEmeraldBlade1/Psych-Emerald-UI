-- OG SCRIPT BY I-WIN

local a1 = 0.254829592;
local a2 = -0.284496736;
local a3 = 1.421413741;
local a4 = -1.453152027;
local a5 = 1.061405429;
local p = 0.3275911;
local curTotalNotesHit = 0
local counterUpdated = 0
local actualRatingHere = 0.00
local msDiffTimeLimit = 1200  -- how many ms after hitting a note should the ms rating disappear
local lastMsShowUp = 0
local msTextVisible = false
local ratingNameM = 'N/A'
local questionmark = '?'
local botscore = 0
local songname = 'NILL'
local songTxtv2 = 'NILL'
local combobreak = 0
local maxcombo = 0
local input = 0
font = "vcr.ttf" -- the font that the text will use.


function onCreate()
    songname = getProperty('curSong')
    -- the 540 is the x pos of the text; the 360 is the y pos of the text. Note that y pos is from the top.
    makeLuaText('msTxt', ' ', 0, 540, 360)
    setTextSize('msTxt', 17)
    setTextBorder('msTxt', 2, '000000')
    setTextFont('msTxt', 'pixel.otf')
    addLuaText('msTxt')
    makeLuaText('songTxt', 'NILL', 0, 540, 360)
    setTextSize('songTxt', 17)
    setTextBorder('songTxt', 2, '000000')
    setTextFont('songTxt', font)
    addLuaText('songTxt')
    setProperty('songTxt.y', 700)
    setProperty('songTxt.x', -0)
    makeLuaText('judTxt', 'NILL', 0, 540, 360)
    setTextSize('judTxt', 20)
    setTextBorder('judTxt', 2, '000000')
    setTextFont('judTxt', font)
    addLuaText('judTxt')
    setProperty('judTxt.y', 350)
    setProperty('judTxt.x', 0)
    makeLuaText('pointTxt', 'NILL', 0, 540, 360)
    setTextSize('pointTxt', 20)
    setTextBorder('pointTxt', 2, '000000')
    setTextFont('pointTxt', font)
    addLuaText('pointTxt')
    setProperty('pointTxt.y', 697)
    setProperty('pointTxt.x', 350)
    makeLuaText('rateTxt', 'NILL', 0, 540, 360)
    setTextSize('rateTxt', 20)
    setTextBorder('rateTxt', 2, '000000')
    setTextFont('rateTxt', font)
    addLuaText('rateTxt')
    setProperty('rateTxt.y', 697)
    setProperty('rateTxt.x', 800)
    makeLuaText('accTxt', 'NILL', 0, 540, 360)
    setTextSize('accTxt', 20)
    setTextBorder('accTxt', 2, '000000')
    setTextFont('accTxt', font)
    addLuaText('accTxt')
    setProperty('accTxt.y', 697)
    setProperty('accTxt.x', 550)
    makeLuaText('inputTxt', 'NILL', 0, 540, 360)
    setTextSize('inputTxt', 20)
    setTextBorder('inputTxt', 2, '000000')
    setTextFont('inputTxt', font)
    addLuaText('inputTxt')
    setProperty('inputTxt.y', 0)
    setProperty('inputTxt.x', 0)
 end


function onUpdatePost(elapsed)
    local accuracyP = getProperty('ratingPercent')
    local PRates = getProperty('ratingName')
    local accuracyS = string.format("%.2f", accuracyP)
    local hpP = getProperty('health')
    local hpS = string.format("%.0f", hpP)
    local combo = getProperty('combo')
    local sicksNumber = getProperty('sicks')
    local goodsNumber = getProperty('goods')
    local badsNumber = getProperty('bads')
    local shitsNumber = getProperty('shits')
    local botplay = getProperty('cpuControlled')
    local pm = getProperty('practiceMode')
    local getmissed = misses
    local getscore = score
    songname = getProperty('curSong')

    if ratingNameM == 'SFC' then
        ratingNameM = 'SFC'
    end
    local ratingFull = math.max(actualRatingHere * 100, 0)
    local ratingFullAsStr = string.format("%.2f", ratingFull)

    local tempRatingNameVery = accuracyToRatingString(ratingFull)

    local Accuracy = ratingFullAsStr..'%'
    local ratingNameS = ''..tempRatingNameVery..''
    local ratingNameE = ' ('..ratingNameM..') - '..PRates..''
    local secondsTotal = getProperty('secondsTotal')
	-- start of "update", some variables weren't updated yet
    -- This updates the contents of the score text.
    -- the rating name is not drawn from the game source.
    -- debugPrint(curTotalNotesHit)

    -- DETERMING WHETHER TO HIDE THE MS DIFF
    local curSongPosRightNow = getPropertyFromClass('Conductor', 'songPosition')
    if curSongPosRightNow - lastMsShowUp > msDiffTimeLimit and msTextVisible then
        setProperty('msTxt.y', 700)
        setProperty('msTxt.x', -0)
        setTextString('msTxt', '')
        setTextFont('msTxt', font)
        msTextVisible = true
    end
    setProperty('msTxt.y', 700)
    setProperty('msTxt.x', -0)
    setTextString('msTxt', '')
    setTextFont('msTxt', font)
    songTxtv2 = ''..getProperty('curSong')..''
    setProperty('songTxt.text', songTxtv2)
    judTxtv2 = ''..'Sicks:'..sicksNumber..'\nGoods:'..goodsNumber..'\nBads:'..badsNumber..'\nShits:'..shitsNumber..'\nMisses:'..getmissed..'\nCombo:'..combo..'\n'
    setProperty('judTxt.text', judTxtv2)
    pointTxtv2 = ''..'Score:'..getscore..''
    setProperty('pointTxt.text', pointTxtv2)
    accTxtv2 = ''..'Accuracy:'..Accuracy..''
    setProperty('accTxt.text', accTxtv2)
    inputTxtv2 = ''..'Inputs:'..input..''
    setProperty('inputTxt.text', inputTxtv2)
    if botplay then
        pointTxtv2 = ''..'Score:'..botscore..''
        setProperty('pointTxt.text', pointTxtv2)
    end
    -- UPDATING SCORETXT

    if input == 0 then
        local beforeScoreTxt = ''
        setProperty('scoreTxt.text', beforeScoreTxt)
       --setTextSize('scoreTxt', 16)
       ratingNameM = 'N/A'
       setProperty('scoreTxt.y', 697)
      -- setProperty('scoreTxt.x', 140)
      rateTxtv2 = ''..'Rating:'..ratingNameS..''
      setProperty('rateTxt.text', rateTxtv2)
    else
        local finalScoreTxt = ''
        setProperty('scoreTxt.text', finalScoreTxt)
        ratingNameM = getProperty('ratingFC')
        --setTextSize('scoreTxt', 16)
        setProperty('scoreTxt.y', 697)
      -- setProperty('scoreTxt.x', 0)
        rateTxtv2 = ''..'Rating:'..ratingNameS..''..ratingNameE
         setProperty('rateTxt.text', rateTxtv2)
         tempRatingNameVery = accuracyToRatingString(ratingFull)
    end
    if botplay then
        if input == 0 then
            local beforeScoreTxt = ''
            setProperty('scoreTxt.text', beforeScoreTxt)
         --  setTextSize('scoreTxt', 16)
           ratingNameM = 'N/A'
           setProperty('scoreTxt.y', 697)
         -- setProperty('scoreTxt.x', 200)
         rateTxtv2 = ''..'Rating:'..ratingNameS..''
         setProperty('rateTxt.text', rateTxtv2)
        else
            local finalScoreTxt = ''
            setProperty('scoreTxt.text', finalScoreTxt)
            ratingNameM = getProperty('ratingFC')
           -- setTextSize('scoreTxt', 16)
           setProperty('scoreTxt.y', 697)
           -- setProperty('scoreTxt.x', 200)
           rateTxtv2 = ''..'Rating:'..ratingNameS..''
          setProperty('rateTxt.text', rateTxtv2)
          tempRatingNameVery = accuracyToRatingString(ratingFull)
        end       
    end
    if pm then
        if input == 0 then
            local beforeScoreTxt = 'Accuracy:'..Accuracy..''
            setProperty('scoreTxt.text', beforeScoreTxt)
          -- setTextSize('scoreTxt', 16)
           ratingNameM = 'N/A'
           setProperty('scoreTxt.y', 697)
         -- setProperty('scoreTxt.x', 200)
         rateTxtv2 = ''..'Rating:'..ratingNameS..''
         setProperty('rateTxt.text', rateTxtv2)
        else
            local finalScoreTxt = 'Accuracy:'..Accuracy..''
            setProperty('scoreTxt.text', finalScoreTxt)
            ratingNameM = getProperty('ratingFC')
           -- setTextSize('scoreTxt', 16)
           setProperty('scoreTxt.y', 697)
           -- setProperty('scoreTxt.x', 200)
           rateTxtv2 = ''..'Rating:'..ratingNameS..''
            setProperty('rateTxt.text', rateTxtv2)
            tempRatingNameVery = accuracyToRatingString(ratingFull)
        end       
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then
        strumTime = getPropertyFromGroup('notes', id, 'strumTime')
        songPos = getPropertyFromClass('Conductor', 'songPosition')
        rOffset = getPropertyFromClass('ClientPrefs','ratingOffset')
        botscore = botscore + 350
        input = input + 1
        maxcombo = maxcombo + 1
        updateAccuracy(strumTime, songPos, rOffset)
    end
end

function updateAccuracy(strumTime, songPos, rOffset) -- HELPER FUNCTION
    local noteDiffSign = strumTime - songPos + rOffset
    local noteDiffAbs = math.abs(noteDiffSign)
    local totalNotesForNow = handleNoteDiff(noteDiffAbs)
    -- local rawJudgements = cancelExistingJudgements(noteDiffAbs)
    -- debugPrint(rawJudgements)
    -- local notesHitDiff = totalNotesForNow - rawJudgements
    -- addHits(noteHitDiff)
    showMsDiffOnScreen(noteDiffSign)
    curTotalNotesHit = curTotalNotesHit + totalNotesForNow
    counterUpdated = counterUpdated + 1
    -- curAccuracy = curTotalNotesHit / counterUpdated
    -- debugPrint(curTotalNotesHit)
    -- setHits(curTotalNotesHit)
    -- getProperty(totalNotesHit)
    
    -- debugPrint(curTotalNotesHit / counterUpdated)
    actualRatingHere = curTotalNotesHit / counterUpdated
    setProperty('ratingPercent', math.max(0, actualRatingHere))  -- we technically need this so the game accounts that for the high score
    -- setRatingPercent(actualRatingHere)
    
    -- debugPrint(tln)
    -- setProperty('totalNotesHit', curTotalNotesHit)
    -- setProperty('totalPlayed', counterUpdated)

    -- ratingStr = accuracyToRatingString(curAccuracy * 100)
    -- setProperty('ratingPercent', math.max(0, curAccuracy))
    -- setProperty('ratingName', ratingStr)
end
function showMsDiffOnScreen(diff)  -- remove everything in this function if you don't want ms timings.
    removeLuaText('msTxt', false)
    local msDiffStr = string.format("%.3fms", -diff)
    -- debugPrint(msDiffStr)
    local textColor = ratingTextColor(diff)
    setTextColor('msTxt', textColor)
    setTextString('msTxt', msDiffStr)
    if diff > 399 then
        setTextString('msTxt', '')
    end

    lastMsShowUp =  getPropertyFromClass('Conductor', 'songPosition')
    msTextVisible = true

    -- local msDiffStr = string.format("%.3f", diff)
    -- msDiffStr = msDiffStr + 'ms'
    -- debugPrint(msDiffStr)
 
end
function ratingTextColor(diff)
    local absDiff = math.abs(diff)
    
    if absDiff < 46.0 then
        return '00FFFF'
    elseif absDiff < 91.0 then
        return '008000'
    else
        return 'FF0000'
    end
end



function cancelExistingJudgements(diff) -- HELPER FUNCTION
    if diff < 46.0 then
        return 1.0
    elseif diff < 91.0 then
        return 0.75
    elseif diff < 136.0 then
        return 0.5
    else
        return 0.0
    end
end


function accuracyToRatingString(accuracy) -- HELPER FUNCTION
    -- Please don't cancel me for repeat if else statements blame python 3.10 for not releasing sooner
    if accuracy >= 99.9935 then
        return 'AAAAA'
    elseif accuracy >= 99.980 then
        return 'AAAA:'
    elseif accuracy >= 99.970 then
        return 'AAAA.'
    elseif accuracy >= 99.955 then
        return 'AAAA'
    elseif accuracy >= 99.90 then
        return 'AAA:'
    elseif accuracy >= 99.80 then
        return 'AAA.'
    elseif accuracy >= 99.70 then
        return 'AAA'
    elseif accuracy >= 99 then
        return 'AA:'
    elseif accuracy >= 96.50 then
        return 'AA.'
    elseif accuracy >= 93 then
        return 'AA'
    elseif accuracy >= 90 then
        return 'A:'
    elseif accuracy >= 85 then
        return 'A.'
    elseif accuracy >= 80 then
        return 'A'
    elseif accuracy >= 70 then
        return 'B'
    elseif accuracy >= 60 then
        return 'C'
    else
        return 'D'
    end
end

function handleNoteDiff(diff) -- HELPER FUNCTION
    local maxms = diff
    local ts = 1

    local max_points = 1.0;
    local miss_weight = -1.0; -- used to be -5.5; this should be a lot less harsh.
    local ridic = 5 * ts;
    local max_boo_weight = 166
    local ts_pow = 0.75;
    local zero = 65 * ts^ts_pow
    local power = 2.5;
    local dev = 22.7 * ts^ts_pow

    if (maxms <= ridic) then -- // anything below this (judge scaled) threshold is counted as full pts
        return max_points
    elseif (maxms <= zero) then -- // ma/pa region, exponential
        return max_points * erf((zero - maxms) / dev)
    elseif (maxms <= max_boo_weight) then -- // cb region, linear
        return (maxms - zero) * miss_weight / (max_boo_weight - zero)
    else
        return miss_weight
    end
end

function erf(x)  -- HELPER FUNCTION
    local sign = 1;
    if (x < 0) then
        sign = -1;
    end
    x = math.abs(x);
    local t = 1.0 / (1.0 + p * x);
    local y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x * x);

    return sign * y;
end

function noteMissPress(direction)
    updateAccuracy(400, 0, 0)
end

function noteMiss(id, direction, noteType, isSustainNote)
    updateAccuracy(400, 0, 0)
     combobreak = combobreak + 1
end