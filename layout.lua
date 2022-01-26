local CurrentPage = PageNames[props["page_index"].Value]
if CurrentPage == "Control" then
  table.insert(graphics,{
    Type = "GroupBox",
    Fill = {220,220,220},
    StrokeWidth = 2,
    CornerRadius = 5,
    Position = {9,17},
    Size = {261,204}
  })
  table.insert(graphics,{
    Type = "Text",
    Text = "Click the CSV button below to save a myEvents.csv file your /designs/current_design directory. To access it, in a browser, go to https://<IP of Core>/designs/current_design.",
    Position = {33,22},
    Size = {211,108},
    FontSize = 12,
    HTextAlign = "Center"
  })
  layout["GetLog"] = {
    PrettyName = "Get Log",
    Style = "Button",
    CornerRadius = 8,
    Position = {75,127},
    Size = {125,57},
    Color = {0,0,0}
  }
  layout["Status"] = {
    PrettyName = "Status",
    Style = "Text",
    Position = {56,192},
    Size = {160,16},
    FontSize = 14,
    StrokeWidth = 0;
    Color = {255,255,255,0}
  }
end