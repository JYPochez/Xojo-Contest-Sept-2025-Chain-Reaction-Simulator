#tag Class
Protected Class ChainReactionGameScene
Inherits GameScene
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize Chain Reaction Game Scene
		  Super.Constructor("ChainReactionGame")

		  // Initialize game grid with current difficulty
		  mGameGrid = New ChainReactionGrid(ChainReactionConstants.gCurrentDifficulty)
		  mBackgroundColor = Color.RGB(30, 30, 50)
		  mClickCount = 0
		  mScore = 0
		  mChainReactionBonus = 0
		  mLastDifficulty = ChainReactionConstants.gCurrentDifficulty
		  mGameState = ChainReactionConstants.eLevelStatus.InProgress

		  CalculateGridPosition()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cleanup()
		  // Clean up game scene resources
		  mGameGrid = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Draw(g As Graphics)
		  // Draw game UI and grid
		  Try
		    // Apply transition alpha for fade effects
		    Var alpha As Double = GetTransitionAlpha()
		    If alpha <= 0.0 Then Return

		    // Draw background
		    g.DrawingColor = mBackgroundColor
		    g.FillRectangle(0, 0, SharedConstants.kWindowWidth, SharedConstants.kWindowHeight)

		    // Draw game grid
		    If mGameGrid <> Nil Then
		      mGameGrid.Draw(g, mGridOffsetX, mGridOffsetY)
		    End If

		    // Draw UI elements
		    DrawUI(g)

		    // Draw game over screen if applicable
		    If mGameState = ChainReactionConstants.eLevelStatus.Completed Then
		      DrawGameOverScreen(g)
		    End If

		  Catch e As RuntimeException
		    // Error in drawing routine - continue with rendering
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandleInput(inputData As Dictionary)
		  // Handle game input
		  Try

		    If inputData.HasKey("keyPressed") Then
		      Var keyCode As String = inputData.Value("keyPressed")

		      Select Case keyCode
		      Case Chr(27) // Escape key
		        // ESC key detected
		        // Show confirmation dialog if game is in progress
		        If mGameState = ChainReactionConstants.eLevelStatus.InProgress And mClickCount > 0 Then
		          // Show confirmation dialog
		          Var d As New MessageDialog
		          d.IconType = MessageDialog.IconTypes.Caution
		          d.ActionButton.Caption = "Yes"
		          d.CancelButton.Visible = True
		          d.CancelButton.Caption = "No"
		          d.Message = "Return to Main Menu?"
		          d.Explanation = "Are you sure you want to return to the main menu? Your current game progress will be lost."

		          Var result As MessageDialogButton
		          result = d.ShowModal

		          Select Case result
		          Case d.ActionButton // User clicked "Yes"
		            // User confirmed - return to main menu
		            Router.SwitchToScene(Router.eGameScene.MainMenu)
		          Case d.CancelButton // User clicked "No"
		            // User canceled - stay in game
		            // Do nothing - stay in current game
		          End Select
		        Else
		          // No game in progress, go directly to menu
		          // ESC pressed - return to main menu
		          Router.SwitchToScene(Router.eGameScene.MainMenu)
		        End If
		      Case "r", "R" // Reset key
		        // Reset key pressed
		        ResetGame()
		      Else
		        // Unhandled key input
		      End Select
		    End If

		    If inputData.HasKey("mouseClicked") Then
		      Var mouseX As Integer = inputData.Value("mouseX")
		      Var mouseY As Integer = inputData.Value("mouseY")
		      // Mouse input received
		      HandleMouseClick(mouseX, mouseY)
		    End If

		  Catch e As RuntimeException
		    // Error in input handling
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Init()
		  // Initialize game scene
		  // Initialize game scene

		  // Always reset game state to pick up difficulty changes
		  RefreshForNewDifficulty()

		  // Grid created and positioned

		  SetInitialized(True)
		  // Initialization complete
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(deltaTime As Double)
		  // Check if difficulty changed and we need to refresh
		  If mGameGrid <> Nil And mLastDifficulty <> ChainReactionConstants.gCurrentDifficulty Then
		    // Difficulty changed - refresh game
		    RefreshForNewDifficulty()
		    mLastDifficulty = ChainReactionConstants.gCurrentDifficulty
		  End If

		  // Update game logic
		  Try
		    // Update game grid animations
		    If mGameGrid <> Nil Then
		      mGameGrid.Update(deltaTime)

		      // Check for game completion (only if player has made moves)
		      If mGameState = ChainReactionConstants.eLevelStatus.InProgress And mClickCount > 0 Then
		        If mGameGrid.IsCleared() Then
		          mGameState = ChainReactionConstants.eLevelStatus.Completed
		          CalculateScore()
		          // Game completed
		        End If
		      End If
		    End If

		  Catch e As RuntimeException
		    // Error in update cycle
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RefreshForNewDifficulty()
		  // Force refresh of grid for new difficulty
		  // Refresh for new difficulty
		  ResetGame()
		  mLastDifficulty = ChainReactionConstants.gCurrentDifficulty
		End Sub
	#tag EndMethod


	#tag Method, Flags = &h21
		Private Sub CalculateGridPosition()
		  // Calculate centered grid position
		  Try
		    If mGameGrid <> Nil Then
		      Var gridWidth As Integer = mGameGrid.GetGridPixelWidth()
		      Var gridHeight As Integer = mGameGrid.GetGridPixelHeight()

		      mGridOffsetX = (SharedConstants.kWindowWidth - gridWidth) / 2
		      mGridOffsetY = ((SharedConstants.kWindowHeight - gridHeight) / 2) + 30 // Offset for UI
		    End If

		  Catch e As RuntimeException
		    // Error calculating grid position
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CalculateScore()
		  // Calculate final score based on clicks and performance
		  Try
		    // Calculate final score

		    mScore = ChainReactionConstants.kBaseScore
		    // Start with base score

		    // Bonus for fewer clicks
		    If mClickCount <= ChainReactionConstants.kMinClicksForPerfect Then
		      mScore = mScore + ChainReactionConstants.kPerfectBonus
		      mGameState = ChainReactionConstants.eLevelStatus.Perfect
		      // Perfect score - adding bonus
		    Else
		      // Reduce score based on extra clicks
		      Var extraClicks As Integer = mClickCount - ChainReactionConstants.kMinClicksForPerfect
		      Var penalty As Integer = extraClicks * 5
		      // Apply penalty for extra clicks
		      mScore = mScore - penalty
		      If mScore < 0 Then
		        mScore = 0
		        // Ensure minimum score of 0
		      End If
		    End If

		    // Add chain reaction bonus
		    mScore = mScore + mChainReactionBonus
		    // Add chain reaction bonus

		  Catch e As RuntimeException
		    // Error calculating score
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawGameOverScreen(g As Graphics)
		  // Draw game completion screen
		  Try
		    // Draw semi-transparent overlay
		    g.DrawingColor = Color.RGB(0, 0, 0, 150)
		    g.FillRectangle(0, 0, SharedConstants.kWindowWidth, SharedConstants.kWindowHeight)

		    // Draw completion message
		    g.FontName = "Arial"
		    g.FontSize = 36
		    g.Bold = True
		    g.DrawingColor = Color.RGB(255, 215, 0) // Gold

		    Var message As String
		    If mGameState = ChainReactionConstants.eLevelStatus.Perfect Then
		      message = "PERFECT!"
		    Else
		      message = "LEVEL COMPLETE!"
		    End If

		    Var textWidth As Integer = g.TextWidth(message)
		    Var x As Integer = (SharedConstants.kWindowWidth - textWidth) / 2
		    Var y As Integer = SharedConstants.kWindowHeight / 2 - 60
		    g.DrawText(message, x, y)

		    // Draw score
		    g.FontSize = 24
		    g.Bold = False
		    g.DrawingColor = Color.White
		    Var scoreText As String = "Score: " + Str(mScore)
		    Var scoreWidth As Integer = g.TextWidth(scoreText)
		    Var scoreX As Integer = (SharedConstants.kWindowWidth - scoreWidth) / 2
		    g.DrawText(scoreText, scoreX, y + 50)

		    // Draw clicks
		    Var clickText As String = "Clicks Used: " + Str(mClickCount)
		    Var clickWidth As Integer = g.TextWidth(clickText)
		    Var clickX As Integer = (SharedConstants.kWindowWidth - clickWidth) / 2
		    g.DrawText(clickText, clickX, y + 80)

		    // Draw instructions
		    g.FontSize = 16
		    Var instructions As String = "Press R to play again • ESC for main menu"
		    Var instWidth As Integer = g.TextWidth(instructions)
		    Var instX As Integer = (SharedConstants.kWindowWidth - instWidth) / 2
		    g.DrawText(instructions, instX, y + 120)

		  Catch e As RuntimeException
		    // Error drawing game over screen
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawUI(g As Graphics)
		  // Draw game UI elements
		  Try
		    g.FontName = "Arial"
		    g.FontSize = 18
		    g.Bold = False
		    g.DrawingColor = Color.White

		    // Draw click counter
		    Var clickText As String = "Clicks: " + Str(mClickCount)
		    g.DrawText(clickText, 20, 30)

		    // Draw orb count
		    If mGameGrid <> Nil Then
		      Var orbText As String = "Orbs: " + Str(mGameGrid.GetTotalOrbs())
		      g.DrawText(orbText, 20, 55)
		    End If

		    // Draw score (show projected score during gameplay)
		    Var displayScore As Integer = mScore
		    If mGameState = ChainReactionConstants.eLevelStatus.InProgress And mClickCount > 0 Then
		      // Show projected score during gameplay
		      displayScore = ChainReactionConstants.kBaseScore
		      If mClickCount <= ChainReactionConstants.kMinClicksForPerfect Then
		        displayScore = displayScore + ChainReactionConstants.kPerfectBonus
		      Else
		        Var penalty As Integer = (mClickCount - ChainReactionConstants.kMinClicksForPerfect) * 5
		        displayScore = displayScore - penalty
		        If displayScore < 0 Then displayScore = 0
		      End If
		      // Add current chain reaction bonus
		      displayScore = displayScore + mChainReactionBonus
		    End If
		    Var scoreText As String = "Score: " + Str(displayScore)
		    g.DrawText(scoreText, 20, 80)

		    // Draw instructions at bottom
		    g.FontSize = 14
		    g.DrawingColor = Color.RGB(200, 200, 200)
		    Var instructions As String = "Click cells to add orbs • 4 orbs explode and spread energy • R to reset • ESC for menu"
		    g.DrawText(instructions, 20, SharedConstants.kWindowHeight - 25)

		  Catch e As RuntimeException
		    // Error drawing UI
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleMouseClick(x As Integer, y As Integer)
		  // Handle mouse clicks on grid
		  Try
		    // Handle mouse click

		    If mGameGrid = Nil Then
		      // Game grid not initialized
		      Return
		    End If

		    If mGameState <> ChainReactionConstants.eLevelStatus.InProgress Then
		      // Game not in progress
		      Return
		    End If

		    If mGameGrid.IsAnimating() Then
		      // Grid is animating - ignore click
		      Return
		    End If

		    // Convert click to grid coordinates
		    Var row As Integer
		    Var column As Integer

		    // Convert click to grid coordinates

		    If mGameGrid.GetPositionFromPixels(x, y, mGridOffsetX, mGridOffsetY, row, column) Then
		      // Valid grid click
		      // Valid grid position found

		      // Get current cell state before adding orb
		      Var cell As ChainReactionOrb = mGameGrid.GetCellAt(row, column)
		      If cell <> Nil Then
		        // Get current cell state
		      Else
		        // Invalid cell reference
		      End If

		      // Track orbs before click for chain reaction detection
		      mOrbsBeforeClick = mGameGrid.GetTotalOrbs()

		      If mGameGrid.AddOrb(row, column) Then
		        mClickCount = mClickCount + 1
		        // Orb added successfully

		        // Play click sound effect
		        PlayClickSound()

		        // Wait a moment for chain reactions to complete, then check bonus
		        Timer.CallLater(500, AddressOf CheckForChainReactionBonus)

		        // Check cell state after adding orb
		        // Orb count updated
		      Else
		        // Failed to add orb
		      End If
		    Else
		      // Click outside grid area
		    End If

		  Catch e As RuntimeException
		    // Error handling mouse click
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CheckForChainReactionBonus()
		  // Award bonus points for chain reactions
		  Try
		    If mGameGrid <> Nil Then
		      Var currentOrbs As Integer = mGameGrid.GetTotalOrbs()
		      Var orbsLost As Integer = mOrbsBeforeClick - currentOrbs

		      // Check for chain reaction

		      // Only award bonus if orbs were actually destroyed (chain reaction occurred)
		      If orbsLost > 1 Then // More than just the orb we added was affected
		        Var bonus As Integer = 0
		        If orbsLost >= 10 Then // Large chain reaction
		          bonus = ChainReactionConstants.kLargeChainBonus
		          // Large chain reaction detected
		          PlayChainReactionSound()
		        ElseIf orbsLost >= 4 Then // Significant chain reaction
		          bonus = ChainReactionConstants.kChainReactionBonus
		          // Chain reaction detected
		          PlayExplosionSound()
		        End If

		        If bonus > 0 Then
		          mChainReactionBonus = mChainReactionBonus + bonus
		          // Bonus points awarded
		        End If
		      Else
		        // Single orb added
		      End If
		    End If
		  Catch e As RuntimeException
		    // Error checking chain reaction bonus
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ResetGame()
		  // Reset game to initial state
		  Try
		    // Recreate grid with current difficulty in case it changed
		    mGameGrid = New ChainReactionGrid(ChainReactionConstants.gCurrentDifficulty)
		    CalculateGridPosition()

		    mClickCount = 0
		    mScore = 0
		    mChainReactionBonus = 0
		    mGameState = ChainReactionConstants.eLevelStatus.InProgress

		    // Game reset complete

		  Catch e As RuntimeException
		    // Error resetting game
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PlayClickSound()
		  // Play system beep for mouse clicks
		  System.Beep()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PlayExplosionSound()
		  // Play bomb sound for explosions
		  Try
		    bomb.Play
		  Catch e As RuntimeException
		    System.Beep() // Fallback
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PlayChainReactionSound()
		  // Play bomb sound for chain reactions
		  Try
		    bomb.Play
		  Catch e As RuntimeException
		    System.Beep() // Fallback
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PlayDelayedBombSound()
		  // Helper method for delayed bomb sounds in chain reactions
		  Try
		    bomb.Play // Direct resource access
		  Catch e As RuntimeException
		    // Error playing delayed bomb sound
		  End Try
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mBackgroundColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mClickCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameGrid As ChainReactionGrid
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameState As ChainReactionConstants.eLevelStatus
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGridOffsetX As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGridOffsetY As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScore As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mChainReactionBonus As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOrbsBeforeClick As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastDifficulty As ChainReactionConstants.eDifficultyLevel
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass