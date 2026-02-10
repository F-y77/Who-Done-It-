name = "Who-Done-It"
description = [[

Who fire the building?
Who call the boss?

当玩家执行危险操作时，在聊天框通报所有玩家。例如：点火烧家、召唤BOSS等。

只有玩家烧建筑才会通报，烧树木不会通报。
召唤boss的一瞬间检测最近的一个玩家并进行通报，因为大概率是他召唤的BOSS。
BOSS名称：巨鹿 龙蝇 熊獾 麋鹿鹅 蚁狮 蛤蟆 暗影蛤蟆 帝王蟹 邪天翁 克劳斯 编织者 远古守卫者 天体英雄 风暴之眼 果蝇王
你可以自行修改BOSS名称，只需要在modmain.lua中修改BOSS_NAMES表即可。

版本号：1.2.1



]]
author = "橙小幸"
version = "1.2.1"
forumthread = ""
api_version = 10
priority = 0
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true
client_only_mod = false
all_clients_require_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options = {
    {
        name = "announce_fire",
        label = "建筑着火通报",
        options = {
            { description = "开启", data = true },
            { description = "关闭", data = false },
        },
        default = true,
    },
    {
        name = "announce_boss",
        label = "Boss出现通报",
        options = {
            { description = "开启", data = true },
            { description = "关闭", data = false },
        },
        default = true,
    },
}
