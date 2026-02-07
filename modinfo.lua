name = "Who-Done-It"
description = "当玩家执行危险操作时，在聊天框通报所有玩家。例如：点火烧家、召唤BOSS等。"
author = "橙小幸"
version = "1.0.0"
forumthread = ""
api_version = 10
priority = 0
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true
client_only_mod = false
all_clients_require_mod = false

icon_atlas = ""
icon = ""

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
