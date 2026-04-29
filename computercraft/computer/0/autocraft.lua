local chest_0 = "minecraft:chest_0"
local barrel_0 = "minecraft:barrel_0"
local turtle_1 = "turtle_1"
local item_vault_0 = "create:item_vault_0"
local turtleID = 3
local mapping = {[1] = 4, [2] = 5, [3] = 6, [4] = 0,
                [5] = 13, [6] = 14, [7] = 15, [8] = 0,
                [9] = 22, [10] = 23, [11] = 24, [12] = 0,}
local barrel_slot = {4, 5, 6, 13, 14, 15, 22, 23, 24}
local chest = peripheral.wrap(chest_0)
local barrel = peripheral.wrap(barrel_0)
local turtle = peripheral.wrap(turtle_1)
local item_vault = peripheral.wrap(item_vault_0)


print(chest, "\n",barrel, "\n", turtle)
local function read_recipes()
    local in_file = {"", "", "", "", "", "", "", "", "", "", "", "", ""}
    for i, slot in ipairs(mapping) do
        if slot~=0 then
            local item = barrel.getItemDetail(slot)
            if item then 
                in_file[i] = item.name
                barrel.pushItems(turtle_1, slot, 64, i)
            end
        end
        
    end
    rednet.open("bottom")
    rednet.send(turtleID, "craft")
    local turtleID, message = rednet.receive()
    if message == "complete" then
        chest.pullItems(turtle_1, 1, 64, 1)
    end
    local detal = chest.getItemDetail(1)
    in_file[0] = detal.name
    local file = fs.open("data", "a")
    file.write(in_file[0] .. " = {\"")
    for i = 1,11 do
        file.write("" .. in_file[i] .. "\",\"")
    end
    file.write(in_file[12] .. "\"}\n")
    file.close()
    chest.pushItems(item_vault_0, 1, 64)
    
end

local function craft()
    local recipes = {}

    -- 1. Читаем файл (без расширения)
    local file = fs.open("data", "r")
    if file then
        while true do
            local line = file.readLine()
            if not line then break end
            
            -- Ищем строки с "="
            local name, dataStr = line:match("^(.-)%s*=%s*(.+)$")
            if name then
                name = name:match("^%s*(.-)%s*$") -- убираем лишние пробелы
                
                -- Превращаем {"item","","item"} в таблицу
                local ok, data = pcall(textutils.unserialize, dataStr)
                if ok and type(data) == "table" then
                    table.insert(recipes, {name = name, data = data})
                end
            end
        end
        file.close()
    end

    -- 2. Выводим список
    print("Find recipes: " .. #recipes)
    for i, r in ipairs(recipes) do
        print(i .. ". " .. r.name)
    end

    -- 3. Выбор пользователя
    print("\nNomer:")
    local idx = tonumber(read())

    if idx and recipes[idx] then
        local chosen = recipes[idx]
        print("\n✅ Выбран: " .. chosen.name)
        print("Данные для крафта:")
        for i, item in ipairs(chosen.data) do
            print("  Слот " .. i .. ": " .. (item == "" and "пусто" or item))
        end
        
        -- chosen.data теперь содержит готовый массив. 
        -- Передавай его в свою функцию крафта:
        -- start_crafting(chosen.data)
    else
        print("❌ Неверный номер или файл пуст")
    end
    file.close()
        
end


craft()

-- print("waitng...\n")
-- print("1.New recipe")
-- print("2.Craft item")


-- while true do
--     local a = tonumber(read())
--     if a == 1 then
--         read_recipes()
--     end
--     if a == 2 then
--         craft()
--     end
-- end
