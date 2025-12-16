// Documentation available at https://donadigo.com/tminterface/plugins/api
bool activate;
string filename = "";

void OnRunStep(SimulationManager@ simManager)
{
    if (simManager.PlayerInfo.RaceTime == 100 and activate) {
        ExecuteCommand("load_state " + filename, ExecuteCommandFlags::SuppressOutput);
    }
}


void Render()
{
    if (UI::Begin("Hold load_state")) {
        filename = UI::InputText("StateName", filename);
        if (UI::Button(activate ? "Deactivate" : "Activate")) {
            activate = !activate;
        }
    } UI::End();
}

void Main()
{
    log("Plugin started.");
}

void OnDisabled()
{
}

PluginInfo@ GetPluginInfo()
{
    auto info = PluginInfo();
    info.Name = "Hold State Loader";
    info.Author = "Gl1tch3D";
    info.Version = "v1.0.0";
    info.Description = "Input a file name, and keep loading the state";
    return info;
}
