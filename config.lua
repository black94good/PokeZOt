maxContainers = 7
accountManager = false
namelockManager = false
newPlayerChooseVoc = false
newPlayerSpawnPosX = 1086
newPlayerSpawnPosY = 1135
newPlayerSpawnPosZ = 15
newPlayerTownId = 1
newPlayerLevel = 20
newPlayerMagicLevel = 0
generateAccountNumber = false

lightInterval = 7500
lightChange = 0
startupTime = 351
startupLight = 100

limitPokeballs = 6						
useTeleportWithFly = false
advertisingBlock = ""
allowBlockSpawn = false
	
rateGymSpellInterval = 0.10

redSkullLength = 30 * 24 * 60 * 60
blackSkullLength = 45 * 24 * 60 * 60
dailyFragsToRedSkull = 3
weeklyFragsToRedSkull = 5
monthlyFragsToRedSkull = 10
dailyFragsToBlackSkull = dailyFragsToRedSkull
weeklyFragsToBlackSkull = weeklyFragsToRedSkull
monthlyFragsToBlackSkull = monthlyFragsToRedSkull
dailyFragsToBanishment = dailyFragsToRedSkull
weeklyFragsToBanishment = weeklyFragsToRedSkull
monthlyFragsToBanishment = monthlyFragsToRedSkull
blackSkulledDeathHealth = 40
blackSkulledDeathMana = 0
useBlackSkull = true
useFragHandler = true
advancedFragList = false

notationsToBan = 3
warningsToFinalBan = 4
warningsToDeletion = 5
banLength = 7 * 24 * 60 * 60
killsBanLength = 7 * 24 * 60 * 60
finalBanLength = 30 * 24 * 60 * 60
ipBanishmentLength = 1 * 24 * 60 * 60
broadcastBanishments = true
maxViolationCommentSize = 200
violationNameReportActionType = 2
autoBanishUnknownBytes = false

worldType = "pvp"
protectionLevel = 9000
pvpTileIgnoreLevelAndVocationProtection = true

-- START Pokemon PvP System
pokemonPvpEnabled = true
pokemonPvpMinLevel = 30
pokemonPvpRequireButton = true
pokemonPvpMaxLevelDifference = 10
pokemonPvpReturnDelay = 10
pokemonPvpWhiteSkullTime = 10 * 60
pokemonPvpDailyFragsToRed = 3
pokemonPvpWeeklyFragsToRed = 5
pokemonPvpMonthlyFragsToRed = 10
pokemonPvpDailyFragsToBlack = 6
pokemonPvpWeeklyFragsToBlack = 10
pokemonPvpMonthlyFragsToBlack = 20
pokemonPvpWhiteExpLossPercent = 5
pokemonPvpRedExpLossPercent = 10
pokemonPvpBlackExpLossPercent = 20
pzLocked = 60 * 1000
-- END Pokemon PvP System

huntingDuration = 60 * 1000
criticalHitChance = 7
criticalHitMultiplier = 1
displayCriticalHitNotify = false
removeWeaponAmmunition = true
removeWeaponCharges = true
removeRuneCharges = true
whiteSkullTime = 15 * 60 * 1000
noDamageToSameLookfeet = false
showHealingDamage = false
showHealingDamageForMonsters = false
fieldOwnershipDuration = 5 * 1000
stopAttackingAtExit = false
oldConditionAccuracy = false
loginProtectionPeriod = 10 * 1000
deathLostPercent = 1
stairhopDelay = 0 * 1000
pushCreatureDelay = 1 * 1000
deathContainerId = 0
gainExperienceColor = 215
addManaSpentInPvPZone = true
squareColor = 0
allowFightback = true

worldId = 0
ip = "127.0.0.1"
bindOnlyConfiguredIpAddress = false
loginPort = 7171
gamePort = 7172
adminPort = 7171
statusPort = 7171
loginTries = 10
retryTimeout = 5 * 1000
loginTimeout = 60 * 1000
maxPlayers = 500	-- codificado e limitado para 7
motd = "Bem vindo ao poke curso"
displayOnOrOffAtCharlist = false
onePlayerOnlinePerAccount = false
allowClones = true
serverName = "Curso"
loginMessage = "Bem vindo ao poke curso"
statusTimeout = 5 * 60 * 1000
replaceKickOnLogin = true
forceSlowConnectionsToDisconnect = false
loginOnlyWithLoginServer = false
premiumPlayerSkipWaitList = true

sqlType = "mysql"
sqlHost = "localhost"
sqlPort = 3306
sqlUser = "root"
sqlPass = ""
sqlDatabase = "pokez"
sqlKeepAlive = 0
mysqlReadTimeout = 10
mysqlWriteTimeout = 10
encryptionType = "sha1"

deathListEnabled = true
deathListRequiredTime = 1 * 60 * 1000
deathAssistCount = 19
maxDeathRecords = 10

ingameGuildManagement = false
levelToFormGuild = 40
premiumDaysToFormGuild = 0
guildNameMinLength = 2
guildNameMaxLength = 25

highscoreDisplayPlayers = 15
updateHighscoresAfterMinutes = 60

buyableAndSellableHouses = true
houseNeedPremium = true
bedsRequirePremium = true
levelToBuyHouse = 80
housesPerAccount = 2
houseRentAsPrice = true -- 
housePriceAsRent = false
housePriceEachSquare = 2000
houseRentPeriod = "never"
houseCleanOld = 0 -- tava 0
guildHalls = false

timeBetweenActions = 500
timeBetweenExActions = 500
hotkeyAimbotEnabled = true

mapName = "PokexCyan"
mapAuthor = "dragoniti"
randomizeTiles = false
storeTrash = false
cleanProtectedZones = true
mailboxDisabledTowns = "1"

defaultPriority = "high"
niceLevel = 5
coresUsed = "-1"

optimizeDatabaseAtStartup = false
removePremiumOnInit = false
confirmOutdatedVersion = false

formulaLevel = 5.0
formulaMagic = 1.0
bufferMutedOnSpellFailure = false
spellNameInsteadOfWords = false
emoteSpells = false

allowChangeOutfit = true
allowChangeColors = true
allowChangeAddons = true
disableOutfitsForPrivilegedPlayers = false
addonsOnlyPremium = false

dataDirectory = "data/"
bankSystem = true
displaySkillLevelOnAdvance = false
promptExceptionTracerErrorBox = true
separateViplistPerCharacter = false
maximumDoorLevel = 500
maxMessageBuffer = 10000000

saveGlobalStorage = false
useHouseDataStorage = false
storePlayerDirection = false

checkCorpseOwner = true
monsterLootMessage = 3
monsterLootMessageType = 22

ghostModeInvisibleEffect = false
ghostModeSpellEffects = false

idleWarningTime = 14 * 60 * 1000
idleKickTime = 15 * 60 * 1000
expireReportsAfterReads = 1
playerQueryDeepness = 2
maxItemsPerPZTile = 0
maxItemsPerHouseTile = 0

freePremium = false
premiumForPromotion = true

blessingOnlyPremium = true
blessingReductionBase = 30
blessingReductionDecreament = 5
eachBlessReduction = 8

experienceStages = true
rateExperience = 999
rateExperienceFromPlayers = 1
rateSkill = 1
rateMagic = 1.0
rateLoot = 100000
rateSpawn = 1

rateMonsterHealth = 1.0
rateMonsterMana = 1.0
rateMonsterAttack = 1.0
rateMonsterDefense = 1.0

minLevelThresholdForKilledPlayer = 0.9
maxLevelThresholdForKilledPlayer = 1.1

rateStaminaLoss = 1
rateStaminaGain = 3
rateStaminaThresholdGain = 12
staminaRatingLimitTop = 41 * 60
staminaRatingLimitBottom = 14 * 60
rateStaminaAboveNormal = 1.0
rateStaminaUnderNormal = 1.0
staminaThresholdOnlyPremium = true

experienceShareRadiusX = 30
experienceShareRadiusY = 30
experienceShareRadiusZ = 1
experienceShareLevelDifference = 200 * 200
extraPartyExperienceLimit = 20
extraPartyExperiencePercent = 20
experienceShareActivity = 2 * 60 * 1000

globalSaveEnabled = false
globalSaveHour = 8
shutdownAtGlobalSave = false
cleanMapAtGlobalSave = false

deSpawnRange = 2
deSpawnRadius = 25

maxPlayerSummons = 2
teleportAllSummons = true
teleportPlayerSummons = true

ownerName = "bruno"
ownerEmail = ""
url = ""
location = "Brazil"
displayGamemastersWithOnlineCommand = false

adminLogsEnabled = false
displayPlayersLogging = true
prefixChannelLogs = ""
runFile = ""
outLogName = ""
errorLogName = ""
truncateLogsOnStartup = false
