{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {

      format = "$username$hostname$git_branch$git_status$fill$cmd_duration$time$line_break$directory$character";
      
      add_newline = true;
      
      username = {
      show_always = true;
      style_user = "fg:#73a5b2";
      style_root = "fg:#d03000";
      format = "\\[[$user]($style)";
      };

      fill = {
      symbol="-";
      };
      
      hostname = {
      ssh_only=false;
      style = "fg:default";
      format="@[$hostname]($style)\\]";
      };

      directory = {
      style = "fg:red";
      repo_root_style="fg:cyan";
      format = "[$path]($style) ";
      truncation_length = 8;
      truncation_symbol = "…/";
      truncate_to_repo=false;
      };
      
      git_branch = {
      style = "fg:#fabd2f";
      format = "\\[[[$symbol$branch](fg:#fabd2f)]($style)\\] ";
      };
      
      git_status = {
      style = "fg:#fabd2f";
      format = "\\[[[($all_status$ahead_behind)](fg:#fabd2f)]($style)\\] ";
      };
      
      character = {
      success_symbol = "[>>>](fg:green bold)";
      error_symbol = "[>>>](fg:red bold)";
      vicmd_symbol = "[<](fg:#98971a bold)";
      };
      
      cmd_duration = {
      style="fg:green";
      min_time = 0;
      format = "\\[[$duration]($style)\\]";
      };
      
      time = {
      disabled = false;
      style="fg:bright-purple";
      time_format = "%R";
      format = "\\[[$time]($style)\\] ";
      };
    };
  };
}
