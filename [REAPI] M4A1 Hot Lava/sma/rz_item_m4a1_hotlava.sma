#include <amxmodx>
#include <reapi>
#include <rezp_inc/rezp_main>
#pragma compress 1

new gl_pClass_Human,
	gl_pWeaponImpulse,
	gl_pItem_Index;

public plugin_precache()
{
	register_plugin("[REZOMBIE] Item: M4A1 Hot Lava", REZP_VERSION_STR, "BRUN0")

	rz_add_translate("weapons/m4a1hotlava")

	RZ_CHECK_CLASS_EXISTS(gl_pClass_Human, "class_human");
	RZ_CHECK_WEAPON_EXISTS(gl_pWeaponImpulse, "weapon_m4a1_hotlava")

	new pItem = gl_pItem_Index = rz_item_create("item_m4a1_hotlava")

	rz_item_set(pItem, RZ_ITEM_NAME, "RZ_ITEM_M4A1_HOTLAVA")
	rz_item_set(pItem, RZ_ITEM_COST, 90)
	rz_item_command_add(pItem, "say /m4hotlava")
}

public rz_items_select_pre(id, pItem)
{
	if (pItem != gl_pItem_Index)
		return RZ_CONTINUE

	if (rz_player_get(id, RZ_PLAYER_CLASS) != gl_pClass_Human)
		return RZ_BREAK

	new handle[RZ_MAX_HANDLE_LENGTH]
	rz_weapon_get(gl_pWeaponImpulse, RZ_WEAPON_HANDLE, handle, charsmax(handle))
	if (rz_find_weapon_by_classname(id, handle)) return RZ_SUPERCEDE

	return RZ_CONTINUE
}

public rz_items_select_post(id, pItem)
{
	if (pItem != gl_pItem_Index)
		return

	new reference[RZ_MAX_REFERENCE_LENGTH]
	rz_weapon_get(gl_pWeaponImpulse, RZ_WEAPON_REFERENCE, reference, charsmax(reference))
	rg_give_custom_item(id, reference, GT_REPLACE, gl_pWeaponImpulse)
}