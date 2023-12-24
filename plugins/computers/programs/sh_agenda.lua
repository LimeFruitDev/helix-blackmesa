--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (www.limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN

local PROGRAM = {}
PROGRAM.order = 100
PROGRAM.name = "Agenda"
PROGRAM.icon = "icon16/calendar.png"
PROGRAM.hide = true
PROGRAM.size = {x = 800, y = 600}

local date = ix.date.GetFormatted("%Y-%m-%d")

if CLIENT then
    local program, panel

    function PROGRAM.build()
        local program = desktop:Add("DFrame")
        program:SetSize(PROGRAM.size.x, PROGRAM.size.y)
        program:SetIcon(PROGRAM.icon)
        program:SetTitle(PROGRAM.name)
		program:Center()
        program:RequestFocus()

        panel = program:Add("DHTML")
        panel:Dock(FILL)
        panel:SetAllowLua(true)

        netstream.Start("computerGetAgenda")
    end

    PLUGIN:registerProgram(PROGRAM)
end

netstream.Hook("computerGetAgenda", function(tblAgenda)
    local view = ""
    local agendaItems = ""

    if LocalPlayer():HasClearances("A") then
        view = [[
            <h2>Add Submission</h2>

            <span>Title:</span><br>
            <input type="text" id="submission_title"></input><br>

            <span>Content:</span><br>
            <textarea rows="10" cols="50" id="submission_text"></textarea><br>

            <span>Time:</span><br>
            <input type="datetime-local" value="]] .. date .. [[T00:00" id="submission_time"><br>

            <button type="button" onclick="getInputValue();">OK</button>
        ]]
    end

    for k, v in SortedPairs(tblAgenda, true) do
        agendaItems = agendaItems .. [[
            <div class="submission">
                <span class="title">]] .. v.title .. [[</span>
                <span class="author">]] .. v.author .. [[</span>
                <p>]] .. v.text .. [[</p>
                <span class="time">]] .. v.time .. (v.char == LocalPlayer():GetCharacter():GetID() and '<button style="margin: 0px; float: right;" type="button" onclick="removeAgendaItem(' .. k .. ');">Remove</button>' or "") .. [[</span>
            </div>
        ]]
    end

    local newProgramHTML = [[
        <html>
            <head>
                <style>
                    body {
                        font-family: Tahoma, sans-serif;
                        background-color: white;
                    }
                    button {
                        margin-top: 1rem;
                    }
                    .content {
                        margin: 0 auto;
                        width: 30rem;
                    }
                    .submission {
                        margin-top: 0px;
                        margin-bottom: 2rem;
                        position: relative;
                    }
                    .title {
                        float: left;
                        background-color: #c07000;
                        width: 65%;
                    }
                    .author {
                        float: right;
                        background-color: grey;
                        width: 35%;
                    }
                    .submission p {
                        margin: 0px;
                        min-height: 7.5rem;
                        background-color: #d17600;
                    }
                    .submission .time {
                        float: left;
                        background-color: #c07000;
                        width: 100%;
                    }
                </style>
            </head>
            <body>
                <div class="content">
                    ]] .. view .. [[
        
                    <h2>Agenda</h2>
                    <div class="submissions">
                        ]] .. agendaItems .. [[
                    </div>
                    <script>
                        function getInputValue() {
                            var title = document.getElementById("submission_title").value;
                            var text = document.getElementById("submission_text").value;
                            var time = document.getElementById("submission_time").value;
                            console.log("RUNLUA:netstream.Start(\"computerScheduleAgendaItem\",\""+title+"\",\""+text+"\",\""+time+"\")");
                        }
                        function removeAgendaItem(id) {
                            console.log("RUNLUA:netstream.Start(\"computerRemoveAgendaItem\","+id+")");
                        }
                    </script>
                </div>
            </body>
        </html>
    ]]

    panel:SetHTML(newProgramHTML)
end)

netstream.Hook("computerScheduleAgendaItem", function()
    if IsValid(program) then
        program:Remove()
        PROGRAM.build()
    end

    PLUGIN:runProgram("popup", "Agenda", "Created submission")
end)


netstream.Hook("computerRemoveAgendaItem", function()
    if IsValid(program) then
        program:Remove()
        PROGRAM.build()
    end

    PLUGIN:runProgram("popup", "Agenda", "Removed submission")
end)
