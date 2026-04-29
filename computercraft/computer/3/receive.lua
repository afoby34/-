local barrel_0 = "minecraft:barrel_0"
local barrel = peripheral.wrap(barrel_0)
local senderID = 0
rednet.open("left")
print("Waiting command")
while true do
    local senderID, message = rednet.receive()
    if message == "craft" then
        turtle.craft(64)
        rednet.send(senderID, "complete")
    end
end
