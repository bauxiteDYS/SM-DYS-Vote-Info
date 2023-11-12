#include <sourcemod>

bool HasVoted[32+1];

public Plugin myinfo =
{
	name		= "Dys Vote Info",
	author		= "bauxite",
	description	= "Prints info about who didn't vote",
	version		= "0.1.0",
	url		= "https://github.com/bauxiteDYS/SM-DYS-Voter-Info",
};

public void OnPluginStart()
{
    if (!AddCommandListener(OnVote, "vote"))
    {
        SetFailState("Failed to add command listener");
    }

    if (!AddCommandListener(OnCallVote, "callvote"))
    {
        SetFailState("Failed to add command listener");
    }
}

public Action OnVote(int client, const char[] command, int argc)
{
	HasVoted[client] = true;
	
	return Plugin_Continue;
}

public Action OnCallVote(int client, const char[] command, int argc)
{
	CreateTimer(30.0, PrintNotReady);
	
	for (int i = 1; i <= MaxClients; i += 1)
	{
		HasVoted[i] = false;
	}
	HasVoted[client] = true;
	
	PrintToConsoleAll("Player %N started a vote", client);
	
	return Plugin_Continue;
}

public Action PrintNotReady(Handle timer)
{
	for (int i = 1; i <= MaxClients; i += 1)
	{
		if (HasVoted[i] == false)
		{
			PrintToConsoleAll("Player %N Hasn't voted", i);
		}
	}
	
	return Plugin_Stop;
}
