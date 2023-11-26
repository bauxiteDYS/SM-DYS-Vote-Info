#include <sourcemod>

bool HasVoted[32+1];
bool Vote_Started;

Handle Vote_Timer;

public Plugin myinfo =
{
	name		= "Dys Vote Info",
	author		= "bauxite",
	description	= "Prints info about who didn't vote",
	version		= "0.3.0",
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
	
	return Plugin_Stop;
}

public Action OnCallVote(int client, const char[] command, int argc)
{

	for (int i = 1; i <= MaxClients; i += 1)
	{
		HasVoted[i] = false;
	}
	
	if (IsValidHandle(Vote_Timer))
	{
		KillTimer(Vote_Timer, true);	
	}
	
	Vote_Started = true;
	
	HasVoted[client] = true;
	
	Vote_Timer = CreateTimer(23.0, PrintNotReady);

	PrintToConsoleAll("################################");
	PrintToConsoleAll("Player %N started a vote", client);
	PrintToConsoleAll("################################");
	
	return Plugin_Continue;
}

public Action PrintNotReady(Handle timer)
{
	int NotVoted;

	if (!IsValidHandle(timer))
	{
		Vote_Started = false;
		return Plugin_Stop;
	}

	PrintToConsoleAll("################################");
	PrintToConsoleAll("Players that have not voted:");

	for (int i = 1; i <= MaxClients; i += 1)
	{
		if (HasVoted[i] == false)
		{
			PrintToConsoleAll("%N", i);
			NotVoted++;
		}
	}

	if (NotVoted == 0)
	{
		PrintToConoleAll("Everyone has voted!");
	}

	PrintToConsoleAll("################################");

	Vote_Started = false;
	NotVoted = 0;
	
	if (IsValidHandle(Vote_Timer))
	{
		KillTimer(Vote_Timer, true);	
	}
	
	return Plugin_Stop;
}
