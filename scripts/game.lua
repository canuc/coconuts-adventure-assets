local includeGame = loadfile("/scripts/include.lua");
Characters = includeGame();

local andThen = loadfile("/scripts/andthen.lua");
andThen();

local Game = {};
local Game_mt = { __metatable = {}, __index = Game };
local ANIMATION_TIME = 1000;

function Game:new()
    if self ~= Game then
        return nil, "First argument must be self"
    end

    local o = setmetatable({}, Game_mt)
    o._start = {x= 0.0, y=4.5, z=0.0}
    o._planets = { x= 10.0, y= 10.0, z=10.0}
    o._position = {x= 0.0, y=0.0, z=0.0 }
    o._characters = {}
    o._animations = {}
    o.PROMISE = Promise
    o.RESOLVER = Resolver
    self._charactersCount = 0
    return o
end
setmetatable(Game, { __call = Game.new })

function Game:gameLoaded(mainCharacter)
    self._character = mainCharacter
    local resultPromise = Promise({
        create_character{position={x=2.2,y=-1.3,z=0.0}, descriptor=Characters.NEBULA},
        create_character{position={x=1.4,y=1.5,z=0.0}, scale=1.4, descriptor=Characters.WORLD, texture="/textures/desert_planet.jpg", uniforms={period=70000}},
        create_character{position={x=-1.4,y=-0.5,z=0.2}, scale=1.8, descriptor=Characters.WORLD, texture="/textures/desert_planet.jpg", uniforms={period=90000}},
        create_character{position={x=-4.4,y=-1.5,z=-0.3}, scale=0.8, descriptor=Characters.WORLD, texture="/textures/new_planet.jpg", uniforms={period=400000,glowsPerPeriod=40.0}},
        create_character{position={x=-7.4,y=1.5,z=0.2}, scale=1.2, descriptor=Characters.WORLD, uniforms={period=800000}},
        create_character{position={x=-7.4,y=1.5,z=0.2}, scale=3.0, descriptor=Characters.WORLD, texture="/textures/gas_planet.jpg", uniforms={period=1000000}},
        create_character{position={x=-10.4,y=-0.7,z=0.3}, descriptor=Characters.WORLD, uniforms={period=1000000}},
        create_character{position={x=-13.4,y=0.7,z=0.5}, descriptor=Characters.WORLD},
        create_character{position={x=-15.4,y=-0.2,z=0.0}, descriptor=Characters.WORLD, texture="/textures/planet_greyish.jpg", uniforms={period=70000}},
        create_character{position={x=-17.4,y=0.3,z=0.0}, descriptor=Characters.WORLD, texture="/textures/mars_src.jpg", uniforms={period=30000}},
        create_character{position={x=-21.4,y=-0.4},descriptor=Characters.NEBULA,uniforms={period=300000}},
        create_character{position={x=-24.1,y=0.2},descriptor=Characters.WORLD, texture="/textures/desert_planet.jpg", uniforms={period=30000}},
        create_character{position={x=-30.0,y=0.0},scale=10.0,descriptor=Characters.SUN}
    }):all()

    resultPromise:and_then(function(characters)
       -- for k, v in pairs(characters) do
       -- print("Character: "..k, v:position())
       -- end

       return preload_character(Characters.ASTEROID)
    end,nil):and_then(function(all_preloads)
       unlock_screen()
       create_singleshot(self,self.startGravity,ANIMATION_TIME)
       print "Characters all preloaded and loaded!"
    end,nil)

    local characterPosition = mainCharacter:position()
    print("Handling game character! "," x: "..characterPosition.x," y: "..characterPosition.y," z: "..characterPosition.z)

    self._animations[create_follow({
        offset=     {x=0.0,y=0.0,z=5.0}
    })] = nil

    self._animations[create_camera_animation({
        start=       {x=-20.0,y=0.0,z=0.0},
        finish=      {x=0.0, y=0.0,z=0.0},
        offset_start={x=0.0,y=0.0,z=-5.0},
        offset_end=  {x=0.0,y=0.0,z=-5.0},
        duration=    ANIMATION_TIME,
    })] = nil
    self.stars = 0;
    variable_manager:set("stars", self.stars)

    text_animation({
        start={
            alignment=or_op({TextAlignLeft,TextAlignTop}),
            x=60,
            y=60
        },
        font="Digital-7",
        text="{stars} stars",
        color={
             r=0.223529411,
            g=1.0,
            b=0.07843,
            a=1.0
        }
    },get_time(),0,QUADRATIC_INTERPOLATOR);
    local completeScope = self
    text_animation({
            start={
                alignment=or_op({TextAlignRight,TextAlignTop}),
                x=60,
                y=60
            },
            font="Digital-7",
            text="{fps} f/s",
            color={
                r=0.223529411,
                g=1.0,
                b=0.07843,
                a=1.0
            }
        },get_time(),0,QUADRATIC_INTERPOLATOR);

    create_plane_trigger({normal={
        x=1.0,
        y=0.0,
        z=0.0
    },
        d=-26.0,
        callback=function()
            completeScope:gameWon()
            won()
        end
    })
    print "Game started within lua!";
    create_timer(self,self.timeExipired,300);
end

function Game:gameWon()
    self:gameDone("Flawless Victory",{
        r=0.223529411,
        g=1.0,
        b=0.07843,
        a=1.0
    })
    create_singleshot(self,self.restart,2000+2000)
end

function Game:characterCreated(id,table)
end

function Game:timeExipired()
    self.stars = self.stars + 1
    variable_manager:set("stars", self.stars)
--     print("Timeout called! time: "..get_time())
end

function Game:positionChanged(newpos)
    print(tostring(newpos))
    self._position = newpos;
end

function Game:startGravity()
    unlock_gravity();
end

function Game:characterDied(causeOfDeath)
    deathString = '';

    if (causeOfDeath == Collision) then
        deathString = "Coconut crashed into P3X 513!";
    elseif (causeOfDeath == OutOfBounds) then
        deathString = "Coconut can't leave the galaxy!";
    end

    self:gameDone(deathString)

    create_singleshot(self,self.restart,2000+2000)
end


function Game:gameDone(gameString,textColor)
    if (textColor == nil) then
        textColor={
            r=1.0,
            g=0.0,
            b=0.0,
            a=1.0
        }
    end

    text_animation({
        start={
            alignment=or_op({TextAlignCenterHorizontally,TextAlignTop}),
            x=0,
            y=400
        },
        finish={
            alignment=or_op({TextAlignCenterHorizontally,TextAlignCenterVertically}),
            x=0,
            y=0
        },
        font="Digital-7",
        text=gameString,
        color=textColor,
        shadow={
            x=1,
            y=1,
            opacity=0.3
        }
    },get_time(),2000,QUADRATIC_INTERPOLATOR):and_then(function(animation)
        return text_animation({
            start={
                alignment=or_op({TextAlignCenterHorizontally,TextAlignCenterVertically}),
                x=0,
                y=400
            },
            finish={
                alignment=or_op({TextAlignCenterHorizontally,TextAlignCenterVertically}),
                x=0,
                y=0
            },
            font="Digital-7",
            text=gameString,
            color=textColor,
            shadow={
                x=1,
                y=1,
                opacity=0.3
            }
        },animation,0,QUADRATIC_INTERPOLATOR)
    end);
end

function Game:restart()
    restart()
end


function Game:shutdown()
    print("Shutting down!");
end

return Game;
