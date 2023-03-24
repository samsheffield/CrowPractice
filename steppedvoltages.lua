--- stepped voltage generator
-- in1: clock
-- in2: voltage scaling (sets maximum voltage of outputs)
-- outs: clocked and stepped random voltages
-- use public.quantize = false to turn off quantizing

--[[
  to do:
    - independent control of quantization per channel
--]]

public{quantize = true}

function init()
    input[1].mode('change', 1.0, 0.1, 'rising')
end

input[1].change = function(state)
    --[[ 
        for each output...
        - choose a random voltage with maximum set by in2
        - if no input on in2, use a max range of 5v
    --]]
    for out = 1,4 do
        inputSample = input[2].volts    
        if(math.floor(inputSample) < 1)
        then
            output[out].volts = generateNumber(5)
        else
            -- if there is input over 1v on in2 use that as max range for random voltage
            output[out].volts = generateNumber(inputSample)
        end
        
        print(input[2].volts)
    end
end

function generateNumber(maxVoltage)
    -- and + or work as a sort of ternary operator
    return public.quantize == true and math.ceil(math.random() * maxVoltage) or math.random() * maxVoltage
end
