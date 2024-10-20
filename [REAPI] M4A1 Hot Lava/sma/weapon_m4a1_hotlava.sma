#include <amxmodx>
#include <reapi>
#include <rezp_inc/rezp_main>

new const V_WEAPON_MODEL[] = "models/rezombie/weapons/hotlava/model_v.mdl"
new const P_WEAPON_MODEL[] = "models/rezombie/weapons/hotlava/model_p.mdl"
new const W_WEAPON_MODEL[] = "models/rezombie/weapons/hotlava/model_w.mdl"

new pImpulse

public plugin_precache()
{
	register_plugin("[REZOMBIE] Weapon: M4A1 Hot Lava", REZP_VERSION_STR, "BRUN0")

	rz_trie_create()

	rz_add_translate("weapons/m4a1hotlava")

	new pWeapon = pImpulse = rz_weapon_create("weapon_m4a1_hotlava", "weapon_m4a1")

	set_weapon_var(pWeapon, RZ_WEAPON_NAME, "RZ_WEAPON_M4A1_HOTLAVA_NAME")
	set_weapon_var(pWeapon, RZ_WEAPON_SHORT_NAME, "RZ_WEAPON_M4A1_HOTLAVA_SHORT")
	set_weapon_var(pWeapon, RZ_WEAPON_VIEW_MODEL, V_WEAPON_MODEL)
	set_weapon_var(pWeapon, RZ_WEAPON_PLAYER_MODEL, P_WEAPON_MODEL)
	set_weapon_var(pWeapon, RZ_WEAPON_WORLD_MODEL, W_WEAPON_MODEL)

	set_weapon_var(pWeapon, RZ_WEAPON_GENERIC_DAMAGE, 20.0)
	set_weapon_var(pWeapon, RZ_WEAPON_HEAD_DAMAGE, 150.0)
	set_weapon_var(pWeapon, RZ_WEAPON_CHEST_DAMAGE,	75.0)
	set_weapon_var(pWeapon, RZ_WEAPON_STOMACH_DAMAGE, 50.0)
	set_weapon_var(pWeapon, RZ_WEAPON_ARMS_DAMAGE, 42.0)
	set_weapon_var(pWeapon, RZ_WEAPON_LEGS_DAMAGE, 35.0)

	set_weapon_var(pWeapon, RZ_WEAPON_KNOCKBACK_POWER, 2.5)

	set_weapon_var(pWeapon, RZ_WEAPON_BEAM_CYLINDER, true)
	set_weapon_var(pWeapon, RZ_WEAPON_BEAM_CYLINDER_COLOR, {255, 90, 10, 255})

	set_weapon_var(pWeapon, RZ_WEAPON_BEAM_POINTER, true)
	set_weapon_var(pWeapon, RZ_WEAPON_BEAM_POINTER_LIFE, 1)
	set_weapon_var(pWeapon, RZ_WEAPON_BEAM_POINTER_WIDTH, 3)

	set_weapon_var(pWeapon, RZ_WEAPON_BEAM_POINTER_COLOR, {255, 90, 10, 255})
	set_weapon_var(pWeapon, RZ_WEAPON_BEAM_POINTER_NOISE_MIN, 0)
	set_weapon_var(pWeapon, RZ_WEAPON_BEAM_POINTER_NOISE_MAX, 2)

	// Last fire time
	rz_set_tdata_float(pWeapon, "LastFire", get_gametime())

	// Maximum time the victim stays on fire
	rz_set_tdata_float(pWeapon, "FireTime", 5.0)

	// Time to use fire again
	rz_set_tdata_float(pWeapon, "FireAgain", 6.0)

	// Damage that fire will cause
	rz_set_tdata_float(pWeapon, "FireDamage", 120.0)
}

public plugin_init() {
	RegisterHookChain(RG_CBasePlayer_TakeDamage, "@CBasePlayer_TakeDamage_Pre", .post = false)
}

public plugin_end() {
	rz_trie_destroy()
}

@CBasePlayer_TakeDamage_Pre(const pVictim, const pInflictor, const pAttacker, const Float:damage, const bitsDamageType) {
	if (!(bitsDamageType & DMG_BULLET) || pVictim == pAttacker) {
		return HC_CONTINUE
	}

	if (!is_user_connected(pAttacker) || !is_user_alive(pVictim)) {
		return HC_CONTINUE
	}

	new pActiveItem = get_member(pAttacker, m_pActiveItem);
	if (is_nullent(pActiveItem)) {
		return HC_CONTINUE
	}

	if (!rz_is_weapon_valid(pActiveItem, pImpulse)) {
		return HC_CONTINUE
	}

	if (!rg_is_player_can_takedamage(pVictim, pAttacker)) {
		return HC_CONTINUE
	}

	new Float:pGameTime = get_gametime();

	if (rz_get_tdata_float(pImpulse, "LastFire") <= pGameTime) {
		rz_grenade_set_user_fire(pVictim, pAttacker, rz_get_tdata_float(pImpulse, "FireTime"), rz_get_tdata_float(pImpulse, "FireDamage"))
		rz_set_tdata_float(pImpulse, "LastFire", pGameTime + rz_get_tdata_float(pImpulse, "FireAgain"))
	}

	return HC_CONTINUE
}