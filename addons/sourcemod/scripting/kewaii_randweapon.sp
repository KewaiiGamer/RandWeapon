/* [CS:GO] Rand Weapon
 *
 *  Copyright (C) 2018 Miguel 'Kewaii' Viegas
 * 
 * All Rights reserved
 */
 
#include <sourcemod>
#include <cstrike>
#include <multicolors>
#include <sdktools>
#include <kewlib>


#pragma semicolon 1
#pragma newdecls required

int g_iOpenedCases[MAXPLAYERS] = 0;
ConVar g_Cvar_MaxWeaponsPerRound, g_Cvar_VIPFlag;
int g_iMaxWeapons = 0;

#define PLUGIN_AUTHOR "Kewaii"
#define PLUGIN_VERSION "0.0.1"
#define PLUGIN_TAG 			"{blue}[{darkred}Kewaii RandWeapon{blue}]{green}"

public Plugin myinfo = 
{
	name = "Random Weapon",
	author = PLUGIN_AUTHOR,
	description = "Get random weapon",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/KewaiiGamer"
};

char g_WeaponClasses[][] = {
/* 0*/ "weapon_awp", /* 1*/ "weapon_ak47", /* 2*/ "weapon_m4a1", /* 3*/ "weapon_m4a1_silencer", /* 4*/ "weapon_deagle", /* 5*/ "weapon_usp_silencer", /* 6*/ "weapon_hkp2000", /* 7*/ "weapon_glock", /* 8*/ "weapon_elite", 
/* 9*/ "weapon_p250", /*10*/ "weapon_cz75a", /*11*/ "weapon_fiveseven", /*12*/ "weapon_tec9", /*13*/ "weapon_revolver", /*14*/ "weapon_nova", /*15*/ "weapon_xm1014", /*16*/ "weapon_mag7", /*17*/ "weapon_sawedoff", 
/*18*/ "weapon_m249", /*19*/ "weapon_negev", /*20*/ "weapon_mp9", /*21*/ "weapon_mac10", /*22*/ "weapon_mp7", /*23*/ "weapon_ump45", /*24*/ "weapon_p90", /*25*/ "weapon_bizon", /*26*/ "weapon_famas", /*27*/ "weapon_galilar", 
/*28*/ "weapon_ssg08", /*29*/ "weapon_aug", /*30*/ "weapon_sg556", /*31*/ "weapon_scar20", /*32*/ "weapon_g3sg1" 
};
char g_WeaponNames[][] = {
/* 0*/ "AWP", /* 1*/ "AK47", /* 2*/ "M4A4", /* 3*/ "M4A1-S", /* 4*/ "Deagle", /* 5*/ "USP-S", /* 6*/ "P2000", /* 7*/ "Glock", /* 8*/ "Dual Berettas", 
/* 9*/ "P250", /*10*/ "CZ75-Auto", /*11*/ "Five-SeveN", /*12*/ "Tec-9", /*13*/ "R8 Revolver", /*14*/ "Nova", /*15*/ "XM1014", /*16*/ "MAG-7", /*17*/ "Sawed-Off", 
/*18*/ "M249", /*19*/ "Negev", /*20*/ "MP9", /*21*/ "MAC-10", /*22*/ "MP7", /*23*/ "UMP45", /*24*/ "P90", /*25*/ "PP-Bizon", /*26*/ "Famas", /*27*/ "Galil AR", 
/*28*/ "SSG 08", /*29*/ "AUG", /*30*/ "SG 553", /*31*/ "SCAR-20", /*32*/ "G3SG1" 
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_vipweapon", Command_VIPWeapon);
	HookEvent("round_start", OnRoundStart);
	g_Cvar_MaxWeaponsPerRound = CreateConVar("kewaii_randweapon_maxperround", "1", "Max weapons per  round");
	g_Cvar_VIPFlag = CreateConVar("kewaii_randweapon_vipflag", "a", "Flag that has access to the Randon Weapon");
	AutoExecConfig(true, "kewaii/kewaii_randweapon");
}

public Action OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		g_iOpenedCases[i] = 0;
    }
}

public void OnConfigsExecuted() {
	g_iMaxWeapons = g_Cvar_MaxWeaponsPerRound.IntValue;
}

public Action Command_VIPWeapon(int client, int args)
{
	char player_authid[32], flag[8];
	g_Cvar_VIPFlag.GetString(flag, sizeof(flag));
	GetClientAuthId(client, AuthId_Steam2, player_authid, sizeof(player_authid));
	if (HasClientFlag(client, flag))
	{
		if (g_iOpenedCases[client] == g_iMaxWeapons) 
		{			
			CPrintToChat(client, "%s %t", PLUGIN_TAG, "Reached RandWeapon Limit");
		}
		else
		{
			char weapon[32], weapon_name[32];
			Format(weapon, sizeof(weapon), g_WeaponClasses[GetRandomInt(0, sizeof(g_WeaponClasses))]);
			Format(weapon_name, sizeof(weapon_name), g_WeaponNames[GetRandomInt(0, sizeof(g_WeaponNames))]);
			GivePlayerItem(client, weapon);
			CPrintToChat(client, "%s %t", PLUGIN_TAG, "Won RandWeapon", weapon_name);
			g_iOpenedCases[client]++;
		}
	}
	else
	{
		CPrintToChat(client, "%s %t", PLUGIN_TAG, "No Permission");
	}
	return Plugin_Handled;
}