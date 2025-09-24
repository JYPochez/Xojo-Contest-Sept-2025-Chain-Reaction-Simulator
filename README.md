# Chain Reaction Simulator

**Genre:** Puzzle / Strategy
**Target Resolution:** 1280×720 (Windowed)
**Platform:** Xojo Desktop Application

<img width="1392" height="861" alt="Chain Reaction Simulator" src="https://github.com/user-attachments/assets/6beddfda-15b1-4884-9309-edcaf7a77644" />

## Overview

Chain Reaction Simulator is a strategic puzzle game where players create cascading chain reactions to clear grids of orbs with minimal clicks. The game challenges players to think strategically about orb placement to trigger the most efficient chain reactions possible.

## How to Play

### Objective
Clear the entire grid by creating chain reactions with the minimum number of clicks possible. Strategic planning and understanding chain reaction mechanics are key to achieving high scores.

### Game Mechanics
1. **Orb Placement**: Click on any grid cell to add an orb
2. **Cell Capacity**: Each cell can safely hold up to 3 orbs
3. **Explosion Trigger**: When a cell reaches 4 orbs, it explodes!
4. **Energy Transfer**: Explosions send energy to adjacent cells (up, down, left, right)
5. **Chain Reactions**: When neighboring cells also explode, massive cascades occur
6. **Victory Condition**: Clear ALL orbs from the grid to complete the level

### Controls
- **Mouse Click**: Add orb to selected grid cell
- **R Key**: Reset current game
- **ESC Key**: Return to main menu (with confirmation dialog)
- **Arrow Keys**: Navigate menu options
- **Enter/Space**: Select menu option

### Audio Experience
- **Click Feedback**: System beep for each mouse click interaction
- **Explosion Effects**: Immersive bomb sound for each orb destruction
- **Chain Reactions**: Multiple overlapping bomb sounds create spectacular audio cascades
- **Professional Sound Design**: High-quality MP3 audio assets enhance gameplay immersion

### Difficulty Levels
- **Easy (6×6 Grid)**: Perfect for learning the mechanics
- **Medium (8×8 Grid)**: Balanced challenge for most players
- **Hard (10×10 Grid)**: Requires strategic thinking and planning
- **Expert (12×12 Grid)**: Master level challenge for puzzle experts

## Installation

1. Download the Chain Reaction Simulator application
2. **Shared Foundations Framework Required**: This project depends on the Shared Foundations framework which is available in a separate repository. When you first launch the Xojo project file, Xojo will prompt you for the missing framework files. You will need access to the Shared Foundations repository to properly open and compile this project.
3. Ensure you have sufficient disk space for save files
4. Launch the application
5. Enjoy triggering chain reactions!

## System Requirements

- **Operating System**: Windows, macOS, or Linux (Xojo-supported platforms)
- **Resolution**: Minimum 1280×720 display
- **Memory**: 512 MB RAM minimum
- **Storage**: 50 MB available space for application and save files

## Tips for Success

- **Study the Grid**: Before clicking, analyze the energy levels and positions of orbs
- **Plan Ahead**: Look for tiles that can trigger the largest cascades
- **Corner Strategy**: Sometimes starting from corners or edges creates better chain reactions
- **Patience Pays**: Take time to find the optimal first click - it often determines success
- **Practice**: Use earlier levels to understand chain reaction patterns

## Scoring System

### Base Scoring
- **Base Score**: 1000 points
- **Perfect Bonus**: +500 points (for completing in ≤10 clicks)
- **Click Penalty**: -5 points per click beyond 10

### Chain Reaction Bonuses
- **Chain Reaction Bonus**: +25 points (when 4+ orbs are destroyed)
- **Large Chain Bonus**: +100 points (when 10+ orbs are destroyed)
- **Real-time Display**: See your projected score update as you play

### Scoring Examples
- **≤10 clicks with chain reactions**: 1500+ points
- **50 clicks with good strategy**: 800+ points
- **100+ clicks**: Still positive scores with chain bonuses

## Demo Mode

For contest demonstration purposes, the game includes a built-in demo that showcases:
- Spectacular chain reaction in 30-60 seconds
- Multiple difficulty levels
- Scoring system and visual effects
- Win/lose state demonstrations

## Support

This game was developed for the September 2025 Xojo Contest. For technical information, see the accompanying DEVELOPER.md file.

---

*Challenge yourself to create the most spectacular chain reactions with the fewest moves possible!*
