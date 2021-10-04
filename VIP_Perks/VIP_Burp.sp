#include <sourcemod>
#include <morecolors>
#include <sdktools>
#include <VIP_Core>

#define PLUGIN_AUTHOR "NoyB"
#define PLUGIN_VERSION "1.0"

#define SOUNDS_PATH "extreme/burp"
#define SOUNDS_AMOUNT 5
#define BURP_DELAY 2

int g_iDelayTime[MAXPLAYERS + 1] = 0;

public Plugin myinfo = 
{
	name = "[TF2] VIP - Burp",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/noywastaken"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_burp", Command_Burp, "Make a Burp Sound");
}

public void OnMapStart()
{
	char szBuffer[32];
	for (int i = 1; i <= SOUNDS_AMOUNT; i++)
	{
		FormatEx(szBuffer, sizeof(szBuffer), "%s%i.wav", SOUNDS_PATH, i);
		PrecacheSound(szBuffer, false);
		FormatEx(szBuffer, sizeof(szBuffer), "sound/%s%i.wav", SOUNDS_PATH, i);
		AddFileToDownloadsTable(szBuffer);
	}
}

public void OnClientPostAdminCheck(int client)
{
	g_iDelayTime[client] = 0;
}

public void VIP_OnMenuOpenned(int client, Menu menu)
{
	menu.AddItem("burp", "Burp!");
}

public Action Command_Burp(int client, int args)
{
	if (!VIP_IsPlayerVIP(client))
	{
		CReplyToCommand(client, "%s You are not a {axis}VIP {default}member! type {axis}!vips {default}for info.", PREFIX);
		return Plugin_Handled;
	}
	
	if (GetTime() >= g_iDelayTime[client])
	{
		char szBuffer[32];
		Format(szBuffer, sizeof(szBuffer), "%s%i.wav", SOUNDS_PATH, GetRandomInt(1, SOUNDS_AMOUNT));
		EmitSoundToAll(szBuffer, client);
		
		g_iDelayTime[client] = GetTime() + BURP_DELAY;
	}
	
	return Plugin_Handled;
}