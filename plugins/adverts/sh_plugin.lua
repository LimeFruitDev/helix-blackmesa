--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

local PLUGIN = PLUGIN
PLUGIN.name = "Advert Screens"
PLUGIN.author = "Zoephix"
PLUGIN.description = "Dynamic advert screens for the facility."
PLUGIN.adverts = PLUGIN.adverts or {}

ix.util.Include("sv_plugin.lua")

local dataHTML = nil
local mainHTML = [[
<html>
	<head>
		<style>
		* {margin: 0; padding: 0; border: 0; font-family: Helvetica, Arial, sans-serif; font-weight: 800;}
		#page { width: 100%; height: 81.1%; background-color: white; }
		#box { color: white; height: 100px; float: left; padding-top: 25px; padding-left: 25px; padding-bottom: 25px;}
		#box_right { height: 100px; float: right; padding-top: 50px; padding-right: 25px;}
		#advertimage{ width: 512px; height: 512px; float:left;}
		#advertcontainer{ width: 62%; float: left; padding-left: 25px;}
		#advertcontainer h1 { font-family: "Arial Black", sans-serif; font-weight: 800;}
		#advertcontainer p { font-family: Helvetica, Arial, sans-serif; font-weight: 600;}
		li{padding: 50px;}
		p{font-family: "Times New Roman"; font-size: 26pt;}
		h1{ font-size: 45pt; }
		i {font-size: 20pt; }

		html { overflow-y: hidden; }
		html { overflow-x: hidden; }

		* {
			margin: auto;
			font-family: 'Roboto', sans-serif;
		  }
	  
		  .TopBar {
			background-color: #393939;
			width: 100%;
			display: inline-block;
			padding: 50px;
		  }
	  
		  .Title {
			text-align: left;
			display: inline;
			font-weight: bold;
			margin-left: 115px;
			color: #ffffff;
		  }
	  
		  .Time {
			text-align: right;
			display: inline;
			float: right;
			margin-right: 100px;
			font-weight: regular;
			color: #FFFFFF
		  }
	  
		  .Logo {
			max-width:100%;
			max-height:100%;
			height: 100px;
			width: 100px;
			padding: 0px;
			position: absolute;
			margin-top: -10px;
			margin-left: -17.5px;
		  }
		</style>

		<script>
		window.onload = function() {
			clock();  
			  function clock() {
			  var now = new Date();
			  var timediff = ]]..ix.date.GetFormatted("%H")..[[ - now.getHours();
			  var TwentyFourHour = now.getHours() + timediff;
			  var hour = now.getHours() + timediff;
			  var min = now.getMinutes();
			  var sec = now.getSeconds();
			  var mid = 'PM';
			  if (min < 10) {
				min = "0" + min;
			  }
			  if (hour > 12) {
				hour = hour - 12;
			  }    
			  if(hour==0){ 
				hour=12;
			  }
			  if(TwentyFourHour < 12) {
				 mid = 'AM';
			  }     
			document.getElementById('currentTime').innerHTML = hour+':'+min+':'+sec +' '+mid ;
			  setTimeout(clock, 1000);
			  }
		  }
		</script>

		<!-- jQuery library (served from Google) -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		<!-- bxSlider Javascript file -->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/bxslider/4.2.15/jquery.bxslider.min.js"></script>
		<!-- bxSlider CSS file -->
		<link href="https://cdnjs.cloudflare.com/ajax/libs/bxslider/4.2.15/jquery.bxslider.min.css" rel="stylesheet" />
		<!-- Set auto slide -->
		<script src="https://limefruit.net/game_resources/bmrfnewsjs/auto.js"></script>

	</head>

	<body>
		<div class="TopBar">
			<img class="Logo" src="https://i.imgur.com/LLM3ord.png">
			<!-- <b style="font-size: 60pt" class="Title">BMRF News Channel</b> -->
			<h1 class="Title">BMRF News Channel</h1>
			<h1 id="currentTime" class="Time">1:00:00 PM</h1>
		</div>

		<div id="page">
			<ul class="bxslider">

				{{slides}}	

			</ul>
		</div>

		<script>
			$(document).ready(function(){
				$('.bxslider').bxSlider({
					auto: true,
					pause: 10000,
					pager: true,
					controls: false
				});
			});
		</script>

	</body>
</html>
]]

local function SetInsertHTML(dataHTML)
	if (CLIENT) then
		for _, screen in pairs(ents.FindByClass("nut_advert")) do
			if screen.panel then
				screen.panel:SetHTML(dataHTML)
			end
		end
	end
end

-- A function to compose the HTML template
local function LoadInsertHTML(data)
	if data then
		local insert = ""

		for k, v in SortedPairs(data, true) do
			insert = insert .. [[
				<li>
					<div id='advertimage'>
						<img src=']] ..v.image.. [['>
					</div>

					<div id='advertcontainer'>
						<h1>]] ..v.title.. [[</h1><br>
						<br>
						<p>]] ..v.text.. [[</p>
					</div>
				</li>
			]]
		end

		local dataHTML = string.Replace(mainHTML, "{{slides}}", insert)
		SetInsertHTML(dataHTML)
	else
		local dataHTML = mainHTML
		SetInsertHTML(dataHTML)
	end
end

-- A function to refresh the HTML panel for the client
if (CLIENT) then
	netstream.Hook("advertsGet", function(adverts)
		LoadInsertHTML(adverts)
		PLUGIN.adverts = adverts
	end)
end
