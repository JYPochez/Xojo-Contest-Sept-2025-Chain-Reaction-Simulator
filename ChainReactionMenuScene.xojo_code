#tag Class
Protected Class ChainReactionMenuScene
Inherits GameScene
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize Chain Reaction Main Menu Scene
		  Super.Constructor("ChainReactionMenu")

		  // Initialize menu properties
		  mTitle = ChainReactionConstants.kGameTitle
		  mSubtitle = "Choose your difficulty level"
		  mSelectedOption = 0
		  mMenuOptions.Add("Easy (6x6 Grid)")
		  mMenuOptions.Add("Medium (8x8 Grid)")
		  mMenuOptions.Add("Hard (10x10 Grid)")
		  mMenuOptions.Add("Expert (12x12 Grid)")
		  mMenuOptions.Add("How to Play")
		  mMenuOptions.Add("Exit")

		  mTitleColor = Color.RGB(255, 255, 255)
		  mSelectedColor = Color.RGB(255, 215, 0) // Gold
		  mNormalColor = Color.RGB(200, 200, 200) // Light gray
		  mBackgroundColor = Color.RGB(40, 40, 60) // Dark blue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cleanup()
		  // Clean up menu scene resources
		  mMenuOptions.RemoveAll()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Draw(g As Graphics)
		  // Draw main menu UI
		  Try
		    // Apply transition alpha for fade effects
		    Var alpha As Double = GetTransitionAlpha()
		    If alpha <= 0.0 Then Return

		    // Draw background
		    g.DrawingColor = mBackgroundColor
		    g.FillRectangle(0, 0, SharedConstants.kWindowWidth, SharedConstants.kWindowHeight)

		    // Draw title
		    DrawTitle(g)

		    // Draw menu options
		    DrawMenuOptions(g)

		    // Draw instructions
		    DrawInstructions(g)

		    // Draw version info
		    DrawVersionInfo(g)

		  Catch e As RuntimeException
		    // Error in drawing routine
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawInstructions(g As Graphics)
		  // Draw game instructions at bottom
		  g.FontName = "Arial"
		  g.FontSize = 14
		  g.Bold = False
		  g.DrawingColor = mNormalColor

		  Var instructions As String = "Use ARROW KEYS to navigate • ENTER to select • ESC to exit"
		  Var textWidth As Integer = g.TextWidth(instructions)
		  Var x As Integer = (SharedConstants.kWindowWidth - textWidth) / 2
		  Var y As Integer = SharedConstants.kWindowHeight - 40

		  g.DrawText(instructions, x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawMenuOptions(g As Graphics)
		  // Draw menu options with selection highlight
		  g.FontName = "Arial"
		  g.FontSize = 24
		  g.Bold = True

		  Var startY As Integer = 300
		  Var lineHeight As Integer = 45

		  For i As Integer = 0 To mMenuOptions.LastIndex
		    Var optionText As String = mMenuOptions(i)

		    // Set color based on selection
		    If i = mSelectedOption Then
		      g.DrawingColor = mSelectedColor
		      // Draw selection background
		      Var textWidth As Integer = g.TextWidth(optionText)
		      Var x As Integer = (SharedConstants.kWindowWidth - textWidth) / 2
		      g.DrawingColor = Color.RGB(255, 215, 0, 50) // Semi-transparent gold
		      g.FillRectangle(x - 20, startY + (i * lineHeight) - 30, textWidth + 40, 35)
		      g.DrawingColor = mSelectedColor
		    Else
		      g.DrawingColor = mNormalColor
		    End If

		    // Draw option text centered
		    Var textWidth As Integer = g.TextWidth(optionText)
		    Var x As Integer = (SharedConstants.kWindowWidth - textWidth) / 2
		    Var y As Integer = startY + (i * lineHeight)

		    g.DrawText(optionText, x, y)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawTitle(g As Graphics)
		  // Draw animated title
		  g.FontName = "Arial"
		  g.FontSize = 48
		  g.Bold = True
		  g.DrawingColor = mTitleColor

		  // Center title
		  Var titleWidth As Integer = g.TextWidth(mTitle)
		  Var x As Integer = (SharedConstants.kWindowWidth - titleWidth) / 2
		  Var y As Integer = 100

		  g.DrawText(mTitle, x, y)

		  // Draw subtitle
		  g.FontSize = 18
		  g.Bold = False
		  g.DrawingColor = mNormalColor
		  Var subtitleWidth As Integer = g.TextWidth(mSubtitle)
		  Var subX As Integer = (SharedConstants.kWindowWidth - subtitleWidth) / 2
		  g.DrawText(mSubtitle, subX, y + 40)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawVersionInfo(g As Graphics)
		  // Draw version information
		  g.FontName = "Arial"
		  g.FontSize = 12
		  g.Bold = False
		  g.DrawingColor = Color.RGB(150, 150, 150)

		  Var versionText As String = "Chain Reaction Simulator v1.0 - Contest Entry September 2025"
		  Var textWidth As Integer = g.TextWidth(versionText)
		  Var x As Integer = SharedConstants.kWindowWidth - textWidth - 10
		  Var y As Integer = SharedConstants.kWindowHeight - 15

		  g.DrawText(versionText, x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandleInput(inputData As Dictionary)
		  // Handle menu navigation and selection
		  Try
		    If inputData.HasKey("keyPressed") Then
		      Var keyCode As String = inputData.Value("keyPressed")

		      Select Case keyCode
		      Case Chr(28), Chr(30) // Up arrow key codes
		        // Navigate up
		        mSelectedOption = mSelectedOption - 1
		        If mSelectedOption < 0 Then mSelectedOption = mMenuOptions.LastIndex
		        // Menu option selected

		      Case Chr(29), Chr(31) // Down arrow key codes
		        // Navigate down
		        mSelectedOption = mSelectedOption + 1
		        If mSelectedOption > mMenuOptions.LastIndex Then mSelectedOption = 0
		        // Menu option selected

		      Case Chr(13), Chr(3), " " // Enter, Return, Space
		        // Select current option
		        // Selecting menu option
		        HandleMenuSelection()

		      Case Chr(27) // Escape key
		        // Exit game
		        // ESC pressed - exit game
		        Quit()

		      Else
		        // Unhandled key input
		      End Select
		    End If

		    If inputData.HasKey("mouseClicked") Then
		      Var mouseX As Integer = inputData.Value("mouseX")
		      Var mouseY As Integer = inputData.Value("mouseY")
		      HandleMouseClick(mouseX, mouseY)
		    End If

		  Catch e As RuntimeException
		    // Error in input handling
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleMenuSelection()
		  // Handle menu option selection
		  Select Case mSelectedOption
		  Case 0 // Easy
		    StartGame(ChainReactionConstants.eDifficultyLevel.Easy)
		  Case 1 // Medium
		    StartGame(ChainReactionConstants.eDifficultyLevel.Medium)
		  Case 2 // Hard
		    StartGame(ChainReactionConstants.eDifficultyLevel.Hard)
		  Case 3 // Expert
		    StartGame(ChainReactionConstants.eDifficultyLevel.Expert)
		  Case 4 // How to Play
		    ShowHowToPlay()
		  Case 5 // Exit
		    Quit()
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleMouseClick(x As Integer, y As Integer)
		  // Handle mouse clicks on menu options
		  Var startY As Integer = 300
		  Var lineHeight As Integer = 45

		  For i As Integer = 0 To mMenuOptions.LastIndex
		    Var optionY As Integer = startY + (i * lineHeight)
		    If y >= optionY - 20 And y <= optionY + 20 Then
		      mSelectedOption = i
		      HandleMenuSelection()
		      Return
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Init()
		  // Initialize menu scene
		  SetInitialized(True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ShowHowToPlay()
		  // Navigate to How to Play scene
		  Router.SwitchToScene(Router.eGameScene.HowToPlay)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StartGame(difficulty As ChainReactionConstants.eDifficultyLevel)
		  // Start game with selected difficulty

		  // Store difficulty globally for GameScene to access
		  ChainReactionConstants.gCurrentDifficulty = difficulty

		  // Switch to gameplay scene (the scene will pick up the new difficulty in its Init method)
		  Router.SwitchToScene(Router.eGameScene.GamePlay)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(deltaTime As Double)
		  // Update menu scene (animations, etc.)
		  Try
		    // Could add menu animations here if desired
		    // For now, just update the base scene
		  Catch e As RuntimeException
		    // Error in update cycle
		  End Try
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mBackgroundColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMenuOptions() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNormalColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelectedColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelectedOption As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubtitle As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTitle As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTitleColor As Color
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