--copy places stuff from library into retroblox (lol)
local cleanworkspace = true --clean workspace b4 loading model? (this will get rid of parts in workspace.)
local model = "301582753" --enter in the model id.
local LoadedModel = game:GetObjects("rbxassetid://"..model)[1] --getmodel k..
--remotes
local instancepartremote = game.ReplicatedStorage.RemoteFunctions.InsertContent --remote used for instancing stuff
local changepropertyremote = game.ReplicatedStorage.RemoteFunctions.ChangeObjectPropertyAndReturn --change property...
local firefunction = game.ReplicatedStorage.RemoteEvents.MiscObjectInteraction --function apply on object such as :Destroy()...
--lets get rid of the stuff already in workspace first.
if cleanworkspace then --if we want to clean workspace lets get rid of parts.
local goodbye = {}
for i,v in pairs(workspace:GetDescendants()) do
    if v.ClassName == "Part" then
       table.insert(goodbye, v)
    end
end
firefunction:FireServer(goodbye, "Destroy")
goodbye = {} --clean it ig
end
--now lets create the model
local loadObjects = LoadedModel:GetDescendants()
local loadParts = {} --this will be transitioned from loadObjects
for i,v in pairs(loadObjects) do
    if v.ClassName == "Part" then
        table.insert(loadParts,v)
    end
end
--parts are in an separate table, lets now setup an childadded check to identify each on instance, so we can change the properties.
local loadedServerParts = {} --load in the parts and place them in a table to compare it with the loadParts table.
workspace.ChildAdded:connect(function(part)
    if #loadedServerParts < #loadParts and part.ClassName == "Part" then --only add until loadParts.
        table.insert(loadedServerParts, part)
    end
end)
--instance parts.
--we'll use the baseplate the game provides as a example
for i,v in pairs(loadParts) do
    --wait() --don't load 2fest, we want loadedServerParts to be the same as loadParts
    instancepartremote:InvokeServer("Baseplate", "Building", Vector3.new(0,0,0))
end
--we instanced parts, lets replicate em properties.
local partpropertiesexample = {
    "BrickColor", "Transparency", "Position", "Reflectance", "Material", "Orientation", "Size", "Shape", "CanCollide", "Anchored", "Name"
}
--we don't need a API, as we're just doing part properties.
for i,v in pairs(loadedServerParts) do
    for propertyindex,propertyvalue in pairs(partpropertiesexample) do
        changepropertyremote:InvokeServer({v}, propertyvalue, loadParts[i][propertyvalue])
    end
end
--done just wait for the model to load
