-- Set up the mission
local mission = {
  ["coalition"] = {
    ["red"] = {
      ["country"] = "Russia"
    },
    ["blue"] = {
      ["country"] = "USA"
    }
  },
  ["triggers"] = {}
}

-- Add enemy-controlled airports
local airports = {
  ["Airport 1"] = {
    ["x"] = 10000,
    ["y"] = 10000,
    ["coalition"] = "red"
  },
  ["Airport 2"] = {
    ["x"] = 20000,
    ["y"] = 20000,
    ["coalition"] = "red"
  },
  -- Add more airports as needed
}

-- Add player-controlled airport
local playerAirport = {
  ["x"] = 5000,
  ["y"] = 5000,
  ["coalition"] = "blue"
}

-- Add enemy defenses
local defenses = {
  ["SAM Site 1"] = {
    ["x"] = 12000,
    ["y"] = 12000,
    ["coalition"] = "red"
  },
  ["AAA Site 1"] = {
    ["x"] = 15000,
    ["y"] = 15000,
    ["coalition"] = "red"
  },
  -- Add more defenses as needed
}

-- Add triggers
local triggerCount = 0

-- Trigger to activate when all defenses are destroyed
local defenseTrigger = {
  ["id"] = triggerCount + 1,
  ["name"] = "Defenses Destroyed",
  ["type"] = "EventTrigger",
  ["enabled"] = true,
  ["params"] = {
    ["eventlist"] = {
      {
        ["target"] = "Mission",
        ["eventType"] = "MissionEnd",
        ["name"] = "Mission End",
        ["verb"] = "Trigger",
        ["id"] = 1
      }
    }
  },
  ["actions"] = {
    {
      ["id"] = 1,
      ["params"] = {
        ["enabled"] = true,
        ["action"] = {
          ["id"] = triggerCount + 2,
          ["params"] = {
            ["unitName"] = "Transport Helicopter",
            ["action"] = "Land",
            ["x"] = playerAirport["x"],
            ["y"] = playerAirport["y"],
            ["form"] = "Off Road",
            ["speed"] = "Max",
            ["alt"] = 0,
            ["name"] = "Land Transport Helicopter",
            ["route"] = {
              ["points"] = {
                {
                  ["alt"] = 0,
                  ["x"] = playerAirport["x"],
                  ["y"] = playerAirport["y"],
                  ["name"] = "Landing Zone",
                  ["type"] = "TakeOff",
                  ["action"] = "Land",
                  ["form"] = "Off Road",
                  ["speed"] = "Max",
                  ["task"] = {
                    ["id"] = 1,
                    ["params"] = {
                      ["action"] = {
                        ["id"] = 4,
                        ["params"] = {
                          ["disperseOnAttack"] = false,
                          ["groupName"] = "Infantry Group",
                          ["task"] = {
                            ["id"] = "Embark",
                            ["params"] = {
                              ["embarkOnRoad"] = false,
                              ["embarkation"] = {
                                ["groupId"] = 1,
                                ["type"] = 1
                              }
                            }
                          },
                          ["expend"] = "RTB",
                          ["taskSelected"] = true,
                          ["route"] = {
                            ["points"] = {
                              {
                                ["alt"] = 0,
                                ["x"] = playerAirport["x"],
                                ["y"] = playerAirport["y"],
                                ["name"] = "Landing Zone",
                                ["type"] = "TakeOff",
                                ["action"] = "Land",
                                ["form"] = "Off Road",
                                ["speed"] = "Max"
                              },
                              {
                                ["alt"] = 0,
                                ["x"] = airports["Airport 1"]["x"],
                                ["y"] = airports["Airport 1"]["y"],
                                ["name"] = "Airport 1",
                                ["type"] = "Land",
                                ["action"] = "Land",
                                ["form"] = "Off Road",
                                ["speed"] = "Max"
                              }
                            }
                          },
                          ["task"] = "Ground",
                          ["groupName"] = "Transport Helicopter Group",
                          ["name"] = "Deploy Infantry",
                          ["taskUnhidden"] = true
                        }
                      },
                      ["groupId"] = 2
                    }
                  },
                  ["task"] = {
                    ["id"] = "Nothing",
                    ["params"] = {}
                  }
                }
              }
            },
            ["task"] = {
              ["id"] = "Nothing",
              ["params"] = {}
            }
          }
        }
      }
    }
  }
}

table.insert(mission["triggers"], defenseTrigger)

-- Trigger to activate when airport is captured
local captureTrigger = {
  ["id"] = triggerCount + 2,
  ["name"] = "Airport Captured",
  ["type"] = "EventTrigger",
  ["enabled"] = true,
  ["params"] = {
    ["eventlist"] = {
      {
        ["target"] = "Group",
        ["eventType"] = "Dead",
        ["name"] = "Infantry Dead",
        ["verb"] = "Trigger",
        ["id"] = triggerCount + 3
      }
    }
  },
  ["actions"] = {
    {
      ["id"] = triggerCount + 3,
      ["params"] = {
        ["enabled"] = true,
        ["action"] = {
          ["id"] = triggerCount + 4,
          ["params"] = {
            ["name"] = "Spawn Aircraft",
            ["coalition"] = "blue",
            ["category"] = "Plane",
            ["type"] = "F-18C"
          }
        }
      }
    }
  }
}

table.insert(mission["triggers"], captureTrigger)

-- Trigger to end mission
local missionEndTrigger = {
  ["id"] = triggerCount + 5,
  ["name"] = "Mission End",
  ["type"] = "EventTrigger",
  ["enabled"] = true,
  ["params"] = {
    ["eventlist"] = {
      {
        ["target"] = "Trigger",
        ["eventType"] = "Reached",
        ["name"] = "All Airports Captured",
        ["verb"] = "Trigger",
        ["id"] = triggerCount + 6
      }
    }
  },
  ["actions"] = {
    {
      ["id"] = triggerCount + 6,
      ["params"] = {
        ["enabled"] = true,
        ["action"] = {
          ["id"] = triggerCount + 7,
          ["params"] = {
            ["endMission"] = true
          }
        }
      }
    }
  }
}

table.insert(mission["triggers"], missionEndTrigger)

-- Save the mission
local missionFile = io.open("mission.miz", "w")
missionFile:write(mist.tostring(mission))
missionFile:close()