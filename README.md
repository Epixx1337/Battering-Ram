# Battering Ram

A two-handed battering ram for Qbox / ox_inventory, with a looping animation for breaching doors.

![The battering ram](images/model_hero.png)

| | |
|---|---|
| ![Held](images/in_hand.png) | ![Detail](images/model_detail.png) |

4,460 tris, textures embedded, about 3.2 MB all in.

## Install

Drop the folder in your resources, `ensure batteringram` in server.cfg, then add it to
`ox_inventory/data/weapons.lua`:

```lua
['WEAPON_BATTERINGRAM'] = {
    label = 'Battering Ram',
    weight = 15000,
    durability = 0.05,
},
```

Then `/giveitem <id> WEAPON_BATTERINGRAM` or add it to a shop.

## Animations

The dictionary is `anim@batteringram`, streamed from `stream/anim@batteringram.ycd`.

| clip | length | what it does |
|---|---|---|
| `breach_enter` | 0.42s | carry pose into the wind-up |
| `breach_loop` | 1.00s | wind back, strike, recoil. Loops cleanly |
| `breach_exit` | 0.42s | back to carrying it |

Play the loop while a progress bar runs, then break the door:

```lua
local DICT <const> = 'anim@batteringram'

local function loadDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do Wait(10) end
    return HasAnimDictLoaded(dict)
end

function PlayBreach(duration)
    if not loadDict(DICT) then return false end

    local ped = cache.ped
    TaskPlayAnim(ped, DICT, 'breach_enter', 8.0, -8.0, -1, 0, 0.0, false, false, false)
    Wait(420)
    -- flag 1 = looping
    TaskPlayAnim(ped, DICT, 'breach_loop', 8.0, -8.0, -1, 1, 0.0, false, false, false)
    Wait(duration)
    TaskPlayAnim(ped, DICT, 'breach_exit', 8.0, -8.0, -1, 0, 0.0, false, false, false)
    Wait(420)
    ClearPedTasks(ped)
    return true
end
```

Keep `duration` a multiple of 1000ms so the loop ends on the recoil instead of mid-swing.

If your script hides the weapon and attaches a prop instead, the model is already aligned for bone
28422 (`PH_R_Hand`) with no offset:

```lua
prop = {
    model = `w_me_batteringram`,
    bone = 28422,
    pos = vec3(0.0, 0.0, 0.0),
    rot = vec3(0.0, 0.0, 0.0),
}
```

## How it's held

The carry pose uses the minigun clipset rather than a melee one, which is what gets both hands out
in front on the handles:

```xml
<MotionClipSetHash>weapons@heavy@minigun</MotionClipSetHash>
<MotionFilterHash>BothArms_filter</MotionFilterHash>
<WeaponClipSetHash>weapons@heavy@minigun</WeaponClipSetHash>
<MeleeClipSetHash>melee@large_wpn@streamed_core</MeleeClipSetHash>
```

Without `BothArms_filter` the off hand just hangs at the side. The melee clipsets are left alone so
swinging it still works like any other melee weapon.

The model is built on the minigun's skeleton — all twelve bones kept, only the mesh swapped. An
equipped weapon gets positioned by a transform that isn't exposed anywhere in the rig or the metas,
so reusing the donor skeleton is what makes the hold come out right: the ring handles sit on
`Gun_GripR` and `Gun_GripL`, where the minigun's grips were, and the clipset does the rest.

If you retexture or reshape it, leave those two bones alone or the hands will slide off the handles.

## Files

```
data/weapons.meta             WEAPON_BATTERINGRAM, melee, TwoHanded MeleeClub
data/weaponanimations.meta    the minigun carry clipset
data/weaponarchetypes.meta    model and txd names
data/pedpersonality.meta      ped reactions
stream/w_me_batteringram.ydr  model, textures embedded
stream/anim@batteringram.ycd  the three breach clips
cl_weaponNames.lua            registers the weapon label
```

No separate `.ytd` — the textures live inside the `.ydr`.

## Tweaking the swing

The clips rotate the spine chain (`SKEL_Spine_Root` up to `SKEL_Spine3`), weighted so the bend gets
stronger higher up, with the shoulders following. Driving it from the spine means the whole upper
body carries the ram and the hands stay locked to the handles.

As shipped: 19° of spine bend, 15° at the shoulders, wound back further than it's driven forward so
it loads harder than it delivers. The hands travel 0.575m over 24 frames, with the hit landing on
frame 9 — about a third of the loop, so it snaps forward and takes its time winding back up.

If you want it heavier, push the spine angle up before shortening the loop. Under roughly 20 frames
it starts looking twitchy instead of heavy.

## Credits

Model by [thecrazy_craft](https://sketchfab.com/thecrazy_craft) on Sketchfab —
[Battering Ram](https://sketchfab.com/3d-models/battering-ram-b9922e50a32040178d95de5418e4e0f7),
Free Standard licence. Credit isn't required for that licence, but it's deserved.
