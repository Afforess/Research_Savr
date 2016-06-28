require 'stdlib/table'
require 'stdlib/event/event'

Event.register(defines.events.on_tick, function(event)
    if event.tick % 20 ~= 0 then return end

    table.each(game.forces, function(force)
        local current_research = force.current_research
        if current_research ~= nil then
            save_research_progress(force, current_research, force.research_progress)
        end
    end)
end)

Event.register(defines.events.on_research_started, function(event)
    local force = event.research.force
    local prev_progress = get_research_progress(force, event.research)
    if prev_progress ~= 0 then
        force.research_progress = math.min(1, prev_progress)
    end
end)

Event.register(defines.events.on_research_finished, function(event)
    local force = event.research.force
    save_research_progress(force, event.research, 1)
end)

function save_research_progress(force, tech, amt)
    local force_name = force.name
    if not global.research then global.research = {} end
    if not global.research[force_name] then global.research[force_name] = {} end
    global.research[force_name][tech.name] = amt
end

function get_research_progress(force, tech)
    local force_name = force.name
    if not global.research then return 0 end
    if not global.research[force_name] then return 0 end
    if not global.research[force_name][tech.name] then return 0 end
    return global.research[force_name][tech.name]
end
