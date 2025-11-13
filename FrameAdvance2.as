array<SimulationState@> states;

int nextframe;
int stateNum;
int reverse_frame;

CommandList@ CurrentList = null;
void OnCommandListChanged(CommandList@ prev, CommandList@ current, CommandListChangeReason reason)
{
    @CurrentList = @current;
}

void ForceReloadCurrentList()
{
    if (@CurrentList !is null) {
        CommandList@ clonedList = null;
        if (!CurrentList.Filename.IsEmpty()) {
            @clonedList = CommandList(CurrentList.Filename);
        } else {
            @clonedList = CommandList();
        }

        clonedList.Content = CurrentList.Content;
        clonedList.Process(CommandListProcessOption::OnlyParse);
        SetCurrentCommandList(clonedList);
    }
}

void OnRunStep(SimulationManager@ simManager)
{
    if (nextframe > 1){
        nextframe -= 1;
    } else if (nextframe == 1){
        simManager.SetSpeed(0);
        nextframe = 0;
    }

    if (simManager.RaceTime < 0 and states.Length > 0) {
        states.Clear();
        stateNum = 0;
    }
    stateNum += 1;
    states.Resize(stateNum + 1);
    @states[stateNum] = simManager.SaveState();

}

void Render()
{
    SimulationManager@ simManager = GetSimulationManager();
    if (UI::Begin("Frame Advance 2")) {
        if (UI::Button("Forward",vec2(0,25))) {
            GetSimulationManager().SetSpeed(.2);
            nextframe = 1;
            ForceReloadCurrentList();

        }
        UI::SameLine();
        if (UI::Button("Backward",vec2(0,25))) {
            if (stateNum > 1) {
                simManager.SetSpeed(0);
                stateNum -= 2;
                simManager.RewindToState(states[stateNum], false);
                ForceReloadCurrentList();
            }
            
        }
    
    }  
    UI::End();
}

void Main()
{
    log("Plugin started.");
    RegisterVariable("reverse_frame",2);
    reverse_frame = uint(Math::Max(2, int(GetVariableDouble("reverse_frame"))));
    SetVariable("reverse_frame", reverse_frame);
}

void OnDisabled()
{
}

PluginInfo@ GetPluginInfo()
{
    auto info = PluginInfo();
    info.Name = "Frame Advance v2";
    info.Author = "Author";
    info.Version = "v2.0.0";
    info.Description = "Allows you to advance and rewind frames.";
    return info;
}
