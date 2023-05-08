-- Get the display group for the game window
local gameWindow = game:GetService("UserInputService").Mouse.Icon
local displayGroup = gameWindow.DisplayGroup

-- Create a new TextLabel object to hold the countdown timer
local countdownTimerText = Instance.new("TextLabel")
countdownTimerText.Size = UDim2.new(0, 30, 0, 30)
countdownTimerText.Position = UDim2.new(0.5, 0, 0.98, 0)
countdownTimerText.Parent = displayGroup

-- Set the initial text value of the countdown timer
countdownTimerText.Text = "100"

-- Store the countdown timer on the server
local countdownTimer = {
    Text = countdownTimerText.Text,
    TimeLeft = 100
}
game:GetService("DataStoreService"):GetDataStore("countdownTimer"):SetAsync("countdownTimer", countdownTimer)

-- Start the countdown timer
spawn(function()
    local countdownTimerObject = game:GetService("DataStoreService"):GetDataStore("countdownTimer"):GetAsync("countdownTimer")
    
    if not countdownTimerObject or countdownTimerObject.TimeLeft <= 0 then
        countdownTimerObject = {
            Text = "100",
            TimeLeft = 100
        }
        
        game:GetService("DataStoreService"):GetDataStore("countdownTimer"):SetAsync("countdownTimer", countdownTimerObject)
    end
    
    for i = countdownTimerObject.TimeLeft - 1, 0, -1 do
        countdownTimerObject.Text = i .. ":00"
        game:GetService("ReplicatedStorage").updateCountdownTimer:FireAllClients(countdownTimerObject)
        wait(1)
    end
    
    countdownTimerObject.Visible = false
end)

-- Function to handle incoming network messages
function handleIncomingMessage(messageData)
    countdownTimerText.Text = messageData.Text
end

-- Register the handler for incoming network messages
game:GetService("ReplicatedStorage").updateCountdownTimer.OnClientEvent:Connect(handleIncomingMessage)
