local chest_0 = "minecraft:chest_0"
local barrel_0 = "minecraft:barrel_0"
local turtle_0 = "turtle_0"

local mapping = {[1] = 4, [2] = 5, [3] = 6, [4] = 0,
                [5] = 13, [6] = 14, [7] = 15, [8] = 0,
                [9] = 22, [10] = 23, [11] = 24, [12] = 0,}
local barrel_slot = {4, 5, 6, 13, 14, 15, 22, 23, 24}
local chest = peripheral.wrap(chest_0)
local barrel = peripheral.wrap(barrel_0)
local turtle = peripheral.wrap(turtle_0)

print(chest, "\n",barrel, "\n", turtle)
for i, slot in ipairs(mapping) do
    if slot~=0 then
        local item = barrel.getItemDetail(slot)
        print(i)
        if item then 
            barrel.pushItems(turtle_0, slot, 64, i)
        end
    end
    
end

