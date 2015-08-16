local meta = FindMetaTable("Player")
if not meta then return end

function meta:IsAdmin()
	return maestro.rankget(self:GetUserGroup()).flags.admin
end

function meta:IsSuperAdmin()
	return maestro.rankget(self:GetUserGroup()).flags.superadmin
end

function meta:IsUserGroup(name)
	return self:GetNWString("rank", "user") == name
end

function meta:GetUserGroup(name)
	return self:GetNWString("rank", "user")
end

if not SERVER then return end

function meta:SetUserGroup(name)
	if not IsValid(self) then return end
	maestro.userrank(self, name)
end

maestro.hook("PlayerAuthed", "maestro_PlayerAuthed", function(ply, steam, uid)
	local name = maestro.userrank(steam)
	if not name then
		maestro.userrank(steam, "user")
	elseif not maestro.rankget(name).flags.anonymous then
		ply:SetNWString("rank", name or "user")
	end
	maestro.sendranks(ply)
end)

hook.Remove("PlayerInitialSpawn", "PlayerAuthSpawn") --removing vanilla stuff resetting rank
