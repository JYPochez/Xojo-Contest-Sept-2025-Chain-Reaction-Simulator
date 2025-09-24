# Chain Reaction Simulator - Developer Documentation

## Application Architecture

Chain Reaction Simulator is built using the Shared Foundations framework, providing a robust scene-based architecture for the Xojo contest environment.

**Important**: This project requires the Shared Foundations framework which is maintained in a separate repository. When opening the project in Xojo for the first time, you will be prompted to locate the missing framework files. The framework components are referenced using relative paths (`../Shared Foundations/`) and must be available in the expected directory structure for successful compilation.

### Project Structure
```
Chain Reaction Simulator.xojo_project
├── Shared Foundations (External Framework)
│   ├── AppTemplate (Module)
│   ├── Router (Module)
│   ├── GameScene (Class)
│   ├── CanvasManager (Class)
│   └── SharedConstants (Module)
├── Game-Specific Components
│   ├── ChainReactionConstants (Module)
│   ├── ChainReactionMenuScene (Class)
│   ├── ChainReactionGameScene (Class)
│   ├── ChainReactionHowToPlayScene (Class)
│   ├── ChainReactionGrid (Class)
│   ├── ChainReactionOrb (Class)
│   └── Window1 (Main Window)
```

## Core Framework (Shared Foundations)

### AppTemplate (Module)
Application lifecycle management and frame coordination.

**Key Methods:**
- `InitializeApplication(window As Window)`: Initialize shared systems
- `UpdateFrame(deltaTime As Double)`: Update current scene
- `RenderFrame(g As Graphics)`: Render current scene
- `CalculateDeltaTime() As Double`: Calculate frame timing
- `ShutdownApplication()`: Clean shutdown sequence

### Router (Module)
Scene management and navigation system.

**Key Methods:**
- `RegisterScene(sceneType, sceneInstance)`: Register game scenes
- `SwitchToScene(sceneType)`: Navigate between scenes
- `HandleInputForCurrentScene(inputData)`: Route input to active scene

### GameScene (Class)
Base class for all game scenes providing common functionality.

**Key Methods:**
- `Constructor(sceneName As String)`: Initialize scene
- `Init()`: Scene initialization hook
- `Update(deltaTime As Double)`: Update logic hook
- `Draw(g As Graphics)`: Rendering hook
- `HandleInput(inputData As Dictionary)`: Input handling hook
- `Cleanup()`: Resource cleanup hook

## Game-Specific Classes

### ChainReactionConstants (Module)
Global constants and enumerations for the game.

**Key Constants:**
```xojo
kBaseScore = 1000              // Base score for completion
kPerfectBonus = 500            // Bonus for ≤10 clicks
kMinClicksForPerfect = 10      // Threshold for perfect bonus
kChainReactionBonus = 25       // Bonus for 4+ orb chain reactions
kLargeChainBonus = 100         // Bonus for 10+ orb chain reactions
kCellSize = 60                 // Grid cell size in pixels
kMaxOrbsPerCell = 4            // Maximum orbs before explosion
```

**Enumerations:**
```xojo
#tag Enum, Name = eDifficultyLevel
    Easy = 0     // 6×6 grid
    Medium = 1   // 8×8 grid
    Hard = 2     // 10×10 grid
    Expert = 3   // 12×12 grid
#tag EndEnum

#tag Enum, Name = eLevelStatus
    NotStarted = 0
    InProgress = 1
    Completed = 2
    Perfect = 3
#tag EndEnum

#tag Enum, Name = eOrbState
    EmptyCell = 0
    OneOrb = 1
    TwoOrbs = 2
    ThreeOrbs = 3
    Critical = 4
    Exploding = 5
#tag EndEnum
```

### ChainReactionOrb (Class)
Represents individual orbs in the grid with state management and visual rendering.

**Key Properties:**
- `mRow, mColumn As Integer`: Grid position
- `mCount As Integer`: Current orb count (0-4)
- `mState As eOrbState`: Current orb state
- `mAnimationTime As Double`: Animation timing

**Key Methods:**
```xojo
Constructor(row, column, initialCount)
  // Initialize orb with position and count

AddOrb() As Boolean
  // Add orb and check for explosion trigger
  // Returns: True if explosion triggered

GetCount() As Integer
  // Get current orb count

IsExploding() As Boolean
  // Check if orb is in explosion state

Update(deltaTime As Double)
  // Handle animation updates

Draw(g As Graphics, x, y, size)
  // Render orb with appropriate visual state
```

### ChainReactionGrid (Class)
Manages the game grid using a 1D array with calculated indices (Xojo limitation workaround).

**Key Properties:**
- `mGrid() As ChainReactionOrb`: 1D array storing all orbs
- `mGridSize As Integer`: Grid dimensions (NxN)
- `mIsAnimating As Boolean`: Animation state flag

**Key Methods:**
```xojo
Constructor(difficulty As eDifficultyLevel)
  // Create grid based on difficulty (6x6 to 12x12)

AddOrb(row, column As Integer) As Boolean
  // Add orb and handle chain reactions
  // Returns: True if orb was added successfully

GetCellAt(row, column As Integer) As ChainReactionOrb
  // Get orb reference at grid position

IsCleared() As Boolean
  // Check if all orbs are cleared (win condition)

Update(deltaTime As Double)
  // Update all orbs and handle chain reactions

Draw(g As Graphics, offsetX, offsetY As Integer)
  // Render entire grid with proper positioning

GetGridIndex(row, column As Integer) As Integer
  // Convert 2D coordinates to 1D array index
  // Implementation: row * mGridSize + column
```

### Scene Classes

#### ChainReactionMenuScene (Class)
Main menu with difficulty selection and navigation.

**Key Features:**
- Arrow key navigation with visual highlighting
- Difficulty level descriptions and grid size indicators
- Professional styling with color-coded selections
- Mouse click support for menu options

**Key Methods:**
```xojo
HandleInput(inputData As Dictionary)
  // Process arrow keys, Enter, ESC, and mouse clicks

HandleMenuSelection()
  // Process selected menu option (difficulty or action)

StartGame(difficulty As eDifficultyLevel)
  // Set global difficulty and switch to gameplay scene
```

#### ChainReactionGameScene (Class)
Core gameplay scene with grid interaction and scoring.

**Key Properties:**
- `mGameGrid As ChainReactionGrid`: The game grid
- `mClickCount As Integer`: Number of clicks made
- `mScore As Integer`: Current calculated score
- `mChainReactionBonus As Integer`: Accumulated chain bonuses
- `mGameState As eLevelStatus`: Current game state
- `mOrbsBeforeClick As Integer`: Orb count tracking for chain detection

**Key Methods:**
```xojo
HandleMouseClick(x, y As Integer)
  // Convert screen coordinates to grid position
  // Add orb and handle chain reaction detection

CalculateScore()
  // Calculate final score with bonuses and penalties
  // Base: 1000, Perfect: +500, Penalty: -5 per extra click

CheckForChainReactionBonus()
  // Detect actual chain reactions by comparing orb counts
  // Award +25 for 4+ orbs destroyed, +100 for 10+ orbs

GetPositionFromPixels(x, y, offsetX, offsetY, ByRef row, column) As Boolean
  // Convert screen coordinates to grid coordinates
```

**Scoring Logic:**
```xojo
Private Sub CalculateScore()
    mScore = kBaseScore
    If mClickCount <= kMinClicksForPerfect Then
        mScore = mScore + kPerfectBonus
        mGameState = eLevelStatus.Perfect
    Else
        Var penalty As Integer = (mClickCount - kMinClicksForPerfect) * 5
        mScore = mScore - penalty
        If mScore < 0 Then mScore = 0
    End If
    // Add accumulated chain reaction bonuses
    mScore = mScore + mChainReactionBonus
End Sub
```

**Chain Reaction Detection:**
```xojo
Private Sub CheckForChainReactionBonus()
    Var orbsLost As Integer = mOrbsBeforeClick - mGameGrid.GetTotalOrbs()
    If orbsLost > 1 Then // Actual chain reaction occurred
        If orbsLost >= 10 Then
            mChainReactionBonus += kLargeChainBonus
        ElseIf orbsLost >= 4 Then
            mChainReactionBonus += kChainReactionBonus
        End If
    End If
End Sub
```

#### ChainReactionHowToPlayScene (Class)
Comprehensive tutorial screen with styled content sections.

**Key Features:**
- Multi-section content layout (Objective, How to Play, Scoring, Tips)
- Color-coded information hierarchy
- Background grid pattern for visual appeal
- Updated scoring information matching actual implementation

## Input Handling System

### Window-Level Events
```xojo
Function KeyDown(key As String) As Boolean
    Var inputData As New Dictionary
    inputData.Value("keyPressed") = key
    Router.HandleInputForCurrentScene(inputData)
    Return True
End Function

Function MouseDown(x, y As Integer) As Boolean
    Var inputData As New Dictionary
    inputData.Value("mouseClicked") = True
    inputData.Value("mouseX") = x
    inputData.Value("mouseY") = y
    Router.HandleInputForCurrentScene(inputData)
    Return True
End Function
```

### Scene-Specific Input Processing
Each scene implements `HandleInput(inputData As Dictionary)` for custom input processing:
- **Menu**: Arrow navigation, Enter selection, ESC exit
- **Game**: Mouse grid clicks, R reset, ESC with confirmation
- **How to Play**: Any key/click returns to menu

## Graphics and Animation

### 60 FPS Game Loop
```xojo
// Timer Period = 16ms for ~60 FPS
Sub Action()
    Var deltaTime As Double = AppTemplate.CalculateDeltaTime()
    AppTemplate.UpdateFrame(deltaTime)
    GameCanvas.Refresh(False) // Trigger Paint event
End Sub
```

### Double Buffering System
```xojo
Sub Paint(g As Graphics, areas() As Rect)
    If mCanvasManager <> Nil Then
        mCanvasManager.BeginFrame()
        Var backBufferGraphics As Graphics = mCanvasManager.GetBackBufferGraphics()
        AppTemplate.RenderFrame(backBufferGraphics)
        mCanvasManager.EndFrame()
        g.DrawPicture(mCanvasManager.GetBackBuffer(), 0, 0)
    Else
        // Fallback rendering
        AppTemplate.RenderFrame(g)
    End If
End Sub
```

### Visual Design
- **Grid Rendering**: 60px cells with border outlines
- **Orb States**: Color-coded orbs (green=1, blue=2, orange=3-4)
- **Animations**: Smooth state transitions and explosion effects
- **UI Elements**: Professional typography and spacing

### Audio System
The game features a professional sound system with distinctive audio feedback:

**Sound Methods:**
```xojo
Private Sub PlayClickSound()
    // System beep for mouse click feedback
    System.Beep()
End Sub

Private Sub PlayExplosionSound()
    // Bomb sound for orb destruction
    Try
        bomb.Play
    Catch e As RuntimeException
        System.Beep() // Fallback
    End Try
End Sub
```

**Audio Resources:**
- **bomb.mp3**: High-quality explosion sound for orb destruction
- **Project Integration**: Sound resource registered as "bomb" in project file
- **Direct Access**: Using `bomb.Play` for reliable playback

**Audio Feedback Design:**
- **Click Events**: System.Beep() for immediate mouse interaction feedback
- **Orb Destruction**: bomb.Play() triggered in ChainReactionGrid.TriggerExplosion()
- **Chain Reactions**: Multiple overlapping bomb sounds create immersive cascades
- **Asynchronous Playback**: Non-blocking audio maintains smooth gameplay

## Contest Compliance Features

### Technical Requirements Met
- **Resolution**: Fixed 1280×720 windowed format
- **Performance**: 60 FPS with smooth animations
- **Error Handling**: Comprehensive try/catch blocks throughout
- **User Experience**: Professional UI with proper confirmation dialogs

### Contest-Specific Features
- **Title Screen**: Professional main menu with game branding
- **How to Play**: Complete instructions and scoring information
- **Win/Lose States**: Game completion screen with score display
- **Reset Functionality**: R key and menu navigation
- **Demo Capability**: 30-60 second gameplay demonstration possible

## Development Techniques

### Xojo-Specific Workarounds
1. **Multi-dimensional Arrays**: Xojo only supports 1D arrays
   ```xojo
   // Workaround: Use calculated indices
   Private Function GetGridIndex(row, column As Integer) As Integer
       Return row * mGridSize + column
   End Function
   ```

2. **Enum Syntax**: Specific formatting required
   ```xojo
   #tag Enum, Name = eOrbState, Type = Integer, Flags = &h0
       EmptyCell = 0
       OneOrb = 1
       // ...
   #tag EndEnum
   ```

3. **MessageBox Limitations**: Custom MessageDialog for Yes/No
   ```xojo
   Var d As New MessageDialog
   d.ActionButton.Caption = "Yes"
   d.CancelButton.Visible = True
   d.CancelButton.Caption = "No"
   // ...
   ```

### Error Handling Strategy
All major methods wrapped in try/catch blocks:
```xojo
Try
    // Game logic here
Catch e As RuntimeException
    System.DebugLog("Method failed: " + e.Message)
End Try
```

### Debug Logging System
Comprehensive logging for troubleshooting:
```xojo
System.DebugLog("Chain check: Before=" + Str(mOrbsBeforeClick) +
    ", After=" + Str(currentOrbs) + ", Lost=" + Str(orbsLost))
```

## Performance Considerations

- **1D Array Implementation**: Efficient grid storage with calculated indices
- **Minimal Object Creation**: Reuse objects during gameplay
- **Optimized Drawing**: Only redraw when necessary
- **Frame Rate Management**: Consistent 60 FPS across platforms
- **Memory Management**: Proper cleanup in scene transitions

## Future Enhancement Possibilities

- **Persistent High Scores**: JSON save file integration
- **Additional Difficulty Modes**: Different grid shapes and mechanics
- **Particle Effects**: Enhanced explosion visuals
- **Sound Effects**: Audio feedback for explosions and UI
- **Multiplayer Support**: Network-based competitive modes
- **Level Editor**: User-created puzzle functionality

---

*This documentation reflects the current state of Chain Reaction Simulator as submitted for the September 2025 Xojo Contest.*