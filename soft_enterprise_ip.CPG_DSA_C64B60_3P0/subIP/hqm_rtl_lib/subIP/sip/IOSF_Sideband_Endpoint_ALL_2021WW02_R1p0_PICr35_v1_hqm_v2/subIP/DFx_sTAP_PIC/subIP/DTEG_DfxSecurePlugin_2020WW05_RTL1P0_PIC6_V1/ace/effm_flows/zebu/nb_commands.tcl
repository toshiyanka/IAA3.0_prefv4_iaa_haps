ZCUI_add -zebuCommands {my_nbq -queue 32G } {}
ZCUI_add -iseCommands {my_nbq -queue 4G -randDelay -randMax 300 } {}
ZCUI_add -synthesisCommands { my_nbq -queue 8G } {}
ZCUI_add -lightProcessCommands t {my_nbq -queue 16G } {}
ZCUI_add -heavyProcessCommands t {my_nbq -queue 32G } {}
ZCUI_add -zTopBuildProcessCommands t {my_nbq -queue 64G } {}

