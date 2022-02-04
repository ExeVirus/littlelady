# Little Lady Roadmap

This game is expected to follow a phased approach to features/completion, and anyone can contribute to any given phase of the development. 

Just be aware that the order with which PR's and other requests are dealt with are going to follow this roadmap. With that, let's jump in.

## Phase 0 - Post Jam Cleanup Release
#### Status: **Complete**

### Goals:
- Update for Minetest 5.5 Release
- Fix known bugs from Game Jam
- Remove needless submodule usage (easier to make commits to)

## Phase 0.1 - Sounds
- Star collection needs a damn sound.

## Phase 1 - Editor and Campaigns 
#### Status: **Ideation/Planning**

### Goals:
- Implement Editor mode within the little lady game itself
    - Ideally without restart
    - Turns off all runtime features, such as stars being collected
    - Has good save, load, and test interface
    - is able to copy an existing level as a template
    - Allows method to edit the welcome message for a given level
- Rework Main menu to support different level sets (campaigns)

## Phase 2 - Features and Multiplayer Co-op
#### Status: **Ideation/Planning**
### Goals:
- Multiplayer co-op really is quite easy to pull off with little lady, only a few tweaks are needed:
    - Make globalstep star captures relavant for all connected players
    - Allow the first connection to be the level selector, and if they leave, the next in line, and so on.
    - Allow the current level selector to defer selection to the next in line
    - Add setting for randomly selected level from all campagins and from single campaign (menu option, ideally)
    - HUD updates for all players upon single star collection
- Implement a new main level set and relagate the current level set to "classic" mode for challenge
- Implement adjustable runtime parameters, especially gravity, step size, and player collision box (if possible)
- New game features: 
    - switches
    - rising air currents
    - walking-ant guards (Zelda OOT style guards)
    - Ability to jump
    - Limited Hover (instead of jump)
    - Bring in [ExeVirus/Falls mod](https://github.com/ExeVirus/falls), because it's fun and beautiful
