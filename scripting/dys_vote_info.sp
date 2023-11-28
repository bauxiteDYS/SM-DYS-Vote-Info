#include <sourcemod>

bool HasVoted[32+1];
bool Vote_Started;

public Plugin myinfo =
{
	name		= "Dys Vote Info",
	author		= "bauxite",
	description	= "Prints info about who didn't vote",
	version		= "0.3.7",
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
	if (Vote_Started == true)
	{
		HasVoted[client] = true;
		return Plugin_Continue;
	}

	return Plugin_Continue;
}

public Action OnCallVote(int client, const char[] command, int argc)
{
	if (Vote_Started == true)
	{
		PrintToConsoleAll("Wait 15s and try again, or fix this bug");
		return Plugin_Stop;
	}
	
	Vote_Started = true;

	for (int i = 1; i <= MaxClients; i++)
	{
		HasVoted[i] = false;
	}	
	
	HasVoted[client] = true;
	
	CreateTimer(15.0, PrintNotReady,_,TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Continue;
}

public Action PrintNotReady(Handle timer)
{
	int NotVotedCount;
	
	Vote_Started = false;

	PrintToConsoleAll("--------------------------------");
	PrintToConsoleAll("Players that haven't voted, yet:");
	PrintToConsoleAll("--------------------------------");
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (HasVoted[i] == false && IsClientInGame(i))
		{
			++NotVotedCount;
			PrintToConsoleAll("%N", i);
			PrintToChatAll("%N hasn't voted", i);
		}
	}
	
	if (NotVotedCount == 0)
	{
		PrintToConsoleAll("Everyone has voted, or nobody has!");
	}
	
	PrintToConsoleAll("--------------------------------");
	
	return Plugin_Continue;
}
