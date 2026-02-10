
GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

-- 仅服务端运行
if not TheNet or not TheNet:GetIsServer() then
    return
end

-- 配置
local ANNOUNCE_FIRE = GetModConfigData and GetModConfigData("announce_fire") ~= false
local ANNOUNCE_BOSS = GetModConfigData and GetModConfigData("announce_boss") ~= false

-- Boss 中文名称映射
local BOSS_NAMES = {
    deerclops = "巨鹿",
    dragonfly = "龙蝇",
    bearger = "熊獾",
    moose = "麋鹿鹅",
    antlion = "蚁狮",
    toadstool = "蛤蟆",
    toadstool_dark = "暗影蛤蟆",
    crabking = "帝王蟹",
    malbatross = "邪天翁",
    klaus = "克劳斯",
    fuelweaver = "编织者",
    ancientguardian = "远古守卫者",
    daywalker = "天体英雄",
    moonstorm_spark = "风暴之眼",
    lordfruitfly = "果蝇王",
}

local function GetBossDisplayName(prefab)
    return BOSS_NAMES[prefab] or prefab
end

-- 获取 Boss 出现位置附近最近的玩家（可能为召唤者或自然生成时的目标玩家）
local function GetNearestPlayerToEntity(inst, max_dist)
    max_dist = max_dist or 60
    local x, y, z = inst.Transform:GetWorldPosition()
    local max_dist_sq = max_dist * max_dist
    local nearest = nil
    local nearest_dist_sq = max_dist_sq
    for _, player in ipairs(AllPlayers or {}) do
        if player and player:IsValid() and player:HasTag("player") and not player:HasTag("playerghost") then
            local dist_sq = player:GetDistanceSqToPoint(x, y, z)
            if dist_sq < nearest_dist_sq then
                nearest_dist_sq = dist_sq
                nearest = player
            end
        end
    end
    return nearest
end

local function GetPlayerDisplayName(player)
    if not player or not player:IsValid() then return nil end
    return (player.GetDisplayName and player:GetDisplayName()) or (player.name and player.name.GetString and player.name:GetString())
end

local function Announce(msg)
    if TheNet and msg and msg ~= "" then
        TheNet:Announce(msg, nil, nil, "mod")
    end
end

-- ========== 建筑着火通报 ==========
AddComponentPostInit("burnable", function(Burnable)
    local old_Ignite = Burnable.Ignite
    Burnable.Ignite = function(self, immediate, source, doer)
        old_Ignite(self, immediate, source, doer)

        if not ANNOUNCE_FIRE then return end

        -- 只通报建筑着火
        local inst = self.inst
        if not inst or not inst:IsValid() then return end
        if not inst:HasTag("structure") then return end

        local msg
        if doer and doer:IsValid() and doer:HasTag("player") then
            local name = (doer.GetDisplayName and doer:GetDisplayName()) or (doer.name and doer.name.GetString and doer.name:GetString()) or "未知玩家"
            msg = ("【警告】%s 点火烧了建筑！"):format(name or "未知玩家")
        else
            msg = "【警告】建筑着火！"
        end
        Announce(msg)
    end
end)

-- ========== Boss 出现通报 ==========
local function OnBossSpawn(inst)
    if not ANNOUNCE_BOSS then return end
    if not inst or not inst:IsValid() then return end

    -- 延迟一帧，确保实体完全初始化
    inst:DoTaskInTime(0, function()
        if not inst:IsValid() then return end
        local boss_name = GetBossDisplayName(inst.prefab)
        local nearby_player = GetNearestPlayerToEntity(inst, 60)
        local msg
        if nearby_player then
            local name = GetPlayerDisplayName(nearby_player) or "未知玩家"
            msg = ("【警告】%s 已出现！(附近: %s)"):format(boss_name, name)
        else
            msg = ("【警告】%s 已出现！"):format(boss_name)
        end
        Announce(msg)
    end)
end

local BOSS_PREFABS = {
    "deerclops", "dragonfly", "bearger", "moose",
    "antlion", "toadstool", "toadstool_dark", "crabking", "malbatross",
    "klaus", "fuelweaver", "ancientguardian", "daywalker", "moonstorm_spark",
    "lordfruitfly",
}

for _, prefab in ipairs(BOSS_PREFABS) do
    AddPrefabPostInit(prefab, OnBossSpawn)
end
