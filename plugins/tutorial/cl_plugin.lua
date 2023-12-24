local PLUGIN = PLUGIN

function PLUGIN:LoadFonts(font)
end

ix.tutorial = ix.tutorial or {}
ix.tutorial.started = false
ix.tutorial.slide = 1
ix.tutorial.skipAllowed = false
ix.tutorial.skipCooldown = CurTime()

ix.tutorial.slides = {
}

function ix.tutorial.start()
	ix.tutorial.started = false
end

function ix.tutorial.finish()
	ix.tutorial.started = false
end
