-- Central loader for TFS 0.3.6 libraries.
-- Keep this list ordered: several legacy systems share global tables/functions.

local dataDirectory = getDataDir()
local loadLibrary = dofile

local libraries = {
	"core/000-constant.lua",
	"core/001-class.lua",
	"core/002-wait.lua",
	"core/004-database.lua",
	"core/011-string.lua",
	"core/012-table.lua",
	"core/031-vocations.lua",
	"core/032-position.lua",
	"core/033-ip.lua",
	"core/034-exhaustion.lua",
	"core/035-item.lua",
	"core/050-function.lua",
	"systems/1 - autoLoot.lua",
	"core/100-compat.lua",
	"systems/Duel System.lua",
	"systems/Golden Arena.lua",
	"systems/GoldenArenaConf.lua",
	"pokemon/IconSys.lua",
	"pokemon/IconsTable.lua",
	"pokemon/Look SystTables.lua",
	"pokemon/Movement_Effects.lua",
	"pokemon/TaskClanSys.lua",
	"pokemon/Wild Trainers.lua",
	"core/areas.lua",
	"pokemon/catch system.lua",
	"pokemon/clan system.lua",
	"core/conditions.lua",
	"pokemon/configuration.lua",
	"pokemon/cooldown bar.lua",
	"pokemon/gym.lua",
	"systems/hisoka functions.lua",
	"pokemon/level system.lua",
	"pokemon/level tables.lua",
	"pokemon/moves.lua",
	"pokemon/newStatusSyst.lua",
	"systems/npcdialog_lib.lua",
	"pokemon/order.lua",
	"pokemon/passivelib.lua",
	"pokemon/pokedex system.lua",
	"pokemon/pokemon moves.lua",
	"systems/quizofdeath.lua",
	"pokemon/some functions.lua",
	"pokemon/status library.lua",
	"systems/task system.lua",
	"systems/tournament.lua",
	"systems/tvsystem.lua"
}

for _, relativePath in ipairs(libraries) do
	loadLibrary(dataDirectory .. "lib/" .. relativePath)
end
