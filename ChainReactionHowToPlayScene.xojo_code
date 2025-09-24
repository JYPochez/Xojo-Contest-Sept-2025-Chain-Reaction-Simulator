#tag Class
Protected Class ChainReactionHowToPlayScene
Inherits GameScene
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize Chain Reaction How To Play Scene
		  Super.Constructor("HowToPlay")

		  mBackgroundColor = Color.RGB(20, 30, 40)
		  mTitleColor = Color.RGB(255, 215, 0) // Gold
		  mHeadingColor = Color.RGB(100, 200, 255) // Light blue
		  mTextColor = Color.RGB(220, 220, 220) // Light gray
		  mHighlightColor = Color.RGB(255, 150, 100) // Orange
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cleanup()
		  // Clean up how to play scene resources
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Draw(g As Graphics)
		  // Draw how to play screen
		  Try
		    // Apply transition alpha for fade effects
		    Var alpha As Double = GetTransitionAlpha()
		    If alpha <= 0.0 Then Return

		    // Draw background
		    g.DrawingColor = mBackgroundColor
		    g.FillRectangle(0, 0, SharedConstants.kWindowWidth, SharedConstants.kWindowHeight)

		    // Draw decorative background pattern
		    DrawBackgroundPattern(g)

		    // Draw title
		    DrawTitle(g)

		    // Draw how to play content
		    DrawHowToPlayContent(g)

		    // Draw navigation instructions
		    DrawNavigationInstructions(g)

		  Catch e As RuntimeException
		    // Error in drawing routine
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawBackgroundPattern(g As Graphics)
		  // Draw subtle grid pattern in background
		  g.DrawingColor = Color.RGB(30, 40, 50, 100) // Semi-transparent

		  Var cellSize As Integer = 40
		  For x As Integer = 0 To SharedConstants.kWindowWidth Step cellSize
		    g.DrawLine(x, 0, x, SharedConstants.kWindowHeight)
		  Next

		  For y As Integer = 0 To SharedConstants.kWindowHeight Step cellSize
		    g.DrawLine(0, y, SharedConstants.kWindowWidth, y)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawHowToPlayContent(g As Graphics)
		  // Draw the main content in two columns
		  Var startY As Integer = 140
		  Var lineHeight As Integer = 24
		  Var leftColumnX As Integer = 60
		  Var rightColumnX As Integer = 660
		  Var columnWidth As Integer = 580

		  // Left Column
		  Var leftY As Integer = startY

		  // Objective section
		  g.FontName = "Arial"
		  g.FontSize = 18
		  g.Bold = True
		  g.DrawingColor = mHeadingColor
		  g.DrawText("OBJECTIVE", leftColumnX, leftY)
		  leftY = leftY + lineHeight + 3

		  g.FontSize = 14
		  g.Bold = False
		  g.DrawingColor = mTextColor
		  g.DrawText("Clear the entire grid by creating chain reactions with minimum clicks.", leftColumnX, leftY)
		  leftY = leftY + lineHeight + 10

		  // How to play section
		  g.FontSize = 18
		  g.Bold = True
		  g.DrawingColor = mHeadingColor
		  g.DrawText("HOW TO PLAY", leftColumnX, leftY)
		  leftY = leftY + lineHeight + 3

		  g.FontSize = 14
		  g.Bold = False
		  g.DrawingColor = mTextColor

		  Var instructions() As String
		  instructions.Add("• Click on any grid cell to add an orb")
		  instructions.Add("• Each cell can hold up to 3 orbs safely")
		  instructions.Add("• When a cell reaches 4 orbs, it EXPLODES!")
		  instructions.Add("• Explosions send energy to adjacent cells")
		  instructions.Add("• Chain reactions occur when neighboring cells explode")
		  instructions.Add("• Goal: Create a chain reaction that clears ALL orbs")

		  For Each instruction As String In instructions
		    g.DrawText(instruction, leftColumnX, leftY)
		    leftY = leftY + lineHeight
		  Next

		  leftY = leftY + 15

		  // Difficulty section
		  g.FontSize = 18
		  g.Bold = True
		  g.DrawingColor = mHeadingColor
		  g.DrawText("DIFFICULTY LEVELS", leftColumnX, leftY)
		  leftY = leftY + lineHeight + 3

		  g.FontSize = 14
		  g.Bold = False
		  g.DrawingColor = mTextColor

		  Var difficulties() As String
		  difficulties.Add("• Easy: 6x6 grid - Great for learning")
		  difficulties.Add("• Medium: 8x8 grid - Balanced challenge")
		  difficulties.Add("• Hard: 10x10 grid - Strategic thinking required")
		  difficulties.Add("• Expert: 12x12 grid - Master level challenge")

		  For Each difficulty As String In difficulties
		    g.DrawText(difficulty, leftColumnX, leftY)
		    leftY = leftY + lineHeight
		  Next

		  // Right Column
		  Var rightY As Integer = startY

		  // Scoring section
		  g.FontSize = 18
		  g.Bold = True
		  g.DrawingColor = mHeadingColor
		  g.DrawText("SCORING", rightColumnX, rightY)
		  rightY = rightY + lineHeight + 3

		  g.FontSize = 14
		  g.Bold = False
		  g.DrawingColor = mTextColor

		  Var scoringRules() As String
		  scoringRules.Add("• Base Score: 1000 points")
		  scoringRules.Add("• Penalty: -5 points for each click beyond 10")
		  scoringRules.Add("• Perfect Bonus: +500 points (≤10 clicks)")
		  scoringRules.Add("• Chain Reaction Bonus: +25 points")
		  scoringRules.Add("• Large Chain Bonus: +100 points")

		  For Each rule As String In scoringRules
		    g.DrawText(rule, rightColumnX, rightY)
		    rightY = rightY + lineHeight
		  Next

		  rightY = rightY + 15

		  // Tips section
		  g.FontSize = 18
		  g.Bold = True
		  g.DrawingColor = mHighlightColor
		  g.DrawText("PRO TIPS", rightColumnX, rightY)
		  rightY = rightY + lineHeight + 3

		  g.FontSize = 14
		  g.Bold = False
		  g.DrawingColor = mHighlightColor

		  Var tips() As String
		  tips.Add("• Start near the center for maximum potential")
		  tips.Add("• Watch for cells with 3 orbs - about to explode!")
		  tips.Add("• Plan multiple explosion chains for efficiency")
		  tips.Add("• Press R during gameplay to reset and try again")
		  tips.Add("• Think ahead - each click matters for your score")
		  tips.Add("• Large chain reactions give bonus points")

		  For Each tip As String In tips
		    g.DrawText(tip, rightColumnX, rightY)
		    rightY = rightY + lineHeight
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawNavigationInstructions(g As Graphics)
		  // Draw navigation help at bottom
		  g.FontName = "Arial"
		  g.FontSize = 16
		  g.Bold = False
		  g.DrawingColor = Color.RGB(255, 255, 255)

		  Var instructions As String = "Press ESC or ENTER to return to main menu"
		  Var textWidth As Integer = g.TextWidth(instructions)
		  Var x As Integer = (SharedConstants.kWindowWidth - textWidth) / 2
		  Var y As Integer = SharedConstants.kWindowHeight - 30

		  // Draw background for better readability
		  g.DrawingColor = Color.RGB(0, 0, 0, 120)
		  g.FillRectangle(x - 10, y - 20, textWidth + 20, 25)

		  g.DrawingColor = Color.RGB(255, 255, 255)
		  g.DrawText(instructions, x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawTitle(g As Graphics)
		  // Draw animated title
		  g.FontName = "Arial"
		  g.FontSize = 36
		  g.Bold = True
		  g.DrawingColor = mTitleColor

		  Var title As String = "HOW TO PLAY CHAIN REACTION"
		  Var titleWidth As Integer = g.TextWidth(title)
		  Var x As Integer = (SharedConstants.kWindowWidth - titleWidth) / 2
		  Var y As Integer = 60

		  // Draw title shadow
		  g.DrawingColor = Color.RGB(0, 0, 0, 150)
		  g.DrawText(title, x + 2, y + 2)

		  // Draw main title
		  g.DrawingColor = mTitleColor
		  g.DrawText(title, x, y)

		  // Draw underline
		  g.DrawingColor = mHeadingColor
		  g.FillRectangle(x, y + 10, titleWidth, 3)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandleInput(inputData As Dictionary)
		  // Handle how to play input
		  Try
		    If inputData.HasKey("keyPressed") Then
		      Var keyCode As String = inputData.Value("keyPressed")

		      Select Case keyCode
		      Case Chr(27), Chr(13), Chr(3), " " // Escape, Enter, Return, Space
		        // Return to main menu
		        // Return to main menu
		        Router.SwitchToScene(Router.eGameScene.MainMenu)
		      Else
		        // Unhandled key input
		      End Select
		    End If

		    If inputData.HasKey("mouseClicked") Then
		      // Any mouse click returns to menu
		      // Mouse click - return to main menu
		      Router.SwitchToScene(Router.eGameScene.MainMenu)
		    End If

		  Catch e As RuntimeException
		    // Error in input handling
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Init()
		  // Initialize how to play scene
		  // Initialize how to play scene
		  SetInitialized(True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(deltaTime As Double)
		  // Update how to play display
		  Try
		    // Could add subtle animations here if desired
		  Catch e As RuntimeException
		    // Error in update cycle
		  End Try
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mBackgroundColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeadingColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHighlightColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTextColor As Color
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