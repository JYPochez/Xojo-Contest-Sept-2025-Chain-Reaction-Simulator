#tag Class
Protected Class ChainReactionGrid
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Default constructor - creates 8x8 grid
		  Constructor(ChainReactionConstants.kDefaultGridSize)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(gridSize As Integer)
		  // Constructor with specified grid size
		  Try
		    // Validate grid size
		    If gridSize < ChainReactionConstants.kMinGridSize Or gridSize > ChainReactionConstants.kMaxGridSize Then
		      gridSize = ChainReactionConstants.kDefaultGridSize
		    End If

		    mGridSize = gridSize
		    mIsAnimating = False
		    mExplosionCount = 0

		    // Initialize grid array
		    InitializeGrid()

		    // Grid initialized

		  Catch e As RuntimeException
		    // Error in constructor
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(difficulty As ChainReactionConstants.eDifficultyLevel)
		  // Constructor with difficulty level
		  Var gridSize As Integer

		  Select Case difficulty
		  Case ChainReactionConstants.eDifficultyLevel.Easy
		    gridSize = 6
		  Case ChainReactionConstants.eDifficultyLevel.Medium
		    gridSize = 8
		  Case ChainReactionConstants.eDifficultyLevel.Hard
		    gridSize = 10
		  Case ChainReactionConstants.eDifficultyLevel.Expert
		    gridSize = 12
		  Else
		    gridSize = ChainReactionConstants.kDefaultGridSize
		  End Select

		  Constructor(gridSize)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AddOrb(row As Integer, column As Integer) As Boolean
		  // Add orb to specified cell and handle explosions
		  Try
		    If Not IsValidPosition(row, column) Then Return False

		    Var cell As ChainReactionOrb = mGrid(GetGridIndex(row, column))

		    // Add orb to cell
		    cell.ReceiveEnergy(1)

		    // Check if explosion is triggered
		    If cell.GetCount() >= ChainReactionConstants.kMaxOrbsPerCell Then
		      TriggerExplosion(row, column)
		    End If

		    Return True

		  Catch e As RuntimeException
		    // Error adding orb
		    Return False
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CheckExplosionChain() As Integer
		  // Check for and trigger chain explosions
		  Var explosionCount As Integer = 0

		  Try
		    For row As Integer = 0 To mGridSize - 1
		      For column As Integer = 0 To mGridSize - 1
		        Var cell As ChainReactionOrb = mGrid(GetGridIndex(row, column))
		        If cell.GetCount() >= ChainReactionConstants.kMaxOrbsPerCell Then
		          TriggerExplosion(row, column)
		          explosionCount = explosionCount + 1
		        End If
		      Next
		    Next

		  Catch e As RuntimeException
		    // Error checking explosion chain
		  End Try

		  Return explosionCount
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Draw(g As Graphics, offsetX As Integer, offsetY As Integer)
		  // Draw the entire grid
		  Try
		    // Draw grid background
		    g.DrawingColor = Color.RGB(20, 20, 20)
		    g.FillRectangle(offsetX, offsetY, GetGridPixelWidth(), GetGridPixelHeight())

		    // Draw grid lines
		    g.DrawingColor = Color.RGB(100, 100, 100)
		    Var cellSize As Integer = GetCellSize()
		    For i As Integer = 0 To mGridSize
		      // Vertical lines
		      Var x As Integer = offsetX + (i * cellSize)
		      g.DrawLine(x, offsetY, x, offsetY + GetGridPixelHeight())

		      // Horizontal lines
		      Var y As Integer = offsetY + (i * cellSize)
		      g.DrawLine(offsetX, y, offsetX + GetGridPixelWidth(), y)
		    Next

		    // Draw orbs in each cell
		    For row As Integer = 0 To mGridSize - 1
		      For column As Integer = 0 To mGridSize - 1
		        Var cell As ChainReactionOrb = mGrid(GetGridIndex(row, column))
		        Var cellX As Integer = offsetX + (column * cellSize)
		        Var cellY As Integer = offsetY + (row * cellSize)

		        cell.Draw(g, cellX, cellY, cellSize)
		      Next
		    Next

		  Catch e As RuntimeException
		    // Error in drawing routine
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCellAt(row As Integer, column As Integer) As ChainReactionOrb
		  // Get orb at specified position
		  Try
		    If IsValidPosition(row, column) Then
		      Return mGrid(GetGridIndex(row, column))
		    End If

		  Catch e As RuntimeException
		    // Error getting cell
		  End Try

		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGridPixelHeight() As Integer
		  // Get total pixel height of grid with dynamic sizing
		  Return mGridSize * GetCellSize()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGridPixelWidth() As Integer
		  // Get total pixel width of grid with dynamic sizing
		  Return mGridSize * GetCellSize()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGridSize() As Integer
		  // Get grid dimensions
		  Return mGridSize
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCellSize() As Integer
		  // Calculate dynamic cell size based on grid size
		  If mGridSize >= 12 Then
		    Return 45  // Smaller cells for expert mode (12x12)
		  ElseIf mGridSize >= 10 Then
		    Return 50  // Medium cells for hard mode (10x10)
		  ElseIf mGridSize >= 8 Then
		    Return 55  // Slightly smaller for medium mode (8x8)
		  Else
		    Return ChainReactionConstants.kCellSize  // Full size for easy mode (6x6)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPositionFromPixels(pixelX As Integer, pixelY As Integer, offsetX As Integer, offsetY As Integer, ByRef row As Integer, ByRef column As Integer) As Boolean
		  // Convert pixel coordinates to grid position
		  Try
		    Var gridX As Integer = pixelX - offsetX
		    Var gridY As Integer = pixelY - offsetY

		    If gridX < 0 Or gridY < 0 Then Return False
		    If gridX >= GetGridPixelWidth() Or gridY >= GetGridPixelHeight() Then Return False

		    Var cellSize As Integer = GetCellSize()
		    column = gridX \ cellSize
		    row = gridY \ cellSize

		    Return IsValidPosition(row, column)

		  Catch e As RuntimeException
		    // Error converting pixel position
		    Return False
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetTotalOrbs() As Integer
		  // Get total number of orbs on grid
		  Var total As Integer = 0

		  Try
		    For row As Integer = 0 To mGridSize - 1
		      For column As Integer = 0 To mGridSize - 1
		        total = total + mGrid(GetGridIndex(row, column)).GetCount()
		      Next
		    Next

		  Catch e As RuntimeException
		    // Error counting orbs
		  End Try

		  Return total
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitializeGrid()
		  // Initialize grid array with empty orbs
		  Try
		    // Use 1D array with calculated indices
		    ReDim mGrid(mGridSize * mGridSize - 1)

		    For i As Integer = 0 To mGrid.LastIndex
		      mGrid(i) = New ChainReactionOrb()
		    Next

		  Catch e As RuntimeException
		    // Error initializing grid
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsAnimating() As Boolean
		  // Check if any animations are running
		  Try
		    If mIsAnimating Then Return True

		    // Check individual cells for animations
		    For row As Integer = 0 To mGridSize - 1
		      For column As Integer = 0 To mGridSize - 1
		        If mGrid(GetGridIndex(row, column)).IsExploding() Then Return True
		      Next
		    Next

		  Catch e As RuntimeException
		    // Error checking animation state
		  End Try

		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsCleared() As Boolean
		  // Check if grid is completely cleared
		  Return GetTotalOrbs() = 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsValidPosition(row As Integer, column As Integer) As Boolean
		  // Check if position is within grid bounds
		  Return row >= 0 And row < mGridSize And column >= 0 And column < mGridSize
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetGridIndex(row As Integer, column As Integer) As Integer
		  // Convert 2D coordinates to 1D array index
		  Return row * mGridSize + column
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  // Reset grid to empty state
		  Try
		    mIsAnimating = False
		    mExplosionCount = 0

		    For row As Integer = 0 To mGridSize - 1
		      For column As Integer = 0 To mGridSize - 1
		        mGrid(GetGridIndex(row, column)).Reset()
		      Next
		    Next

		    // Grid reset complete

		  Catch e As RuntimeException
		    // Error resetting grid
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TriggerExplosion(row As Integer, column As Integer)
		  // Trigger explosion at specified cell
		  Try
		    If Not IsValidPosition(row, column) Then Return

		    Var cell As ChainReactionOrb = mGrid(GetGridIndex(row, column))

		    // Trigger explosion and get energy released
		    Var energyReleased As Integer = cell.Explode()
		    mExplosionCount = mExplosionCount + 1
		    mIsAnimating = True

		    // Play bomb sound for this individual orb destruction
		    Try
		      bomb.Play
		    Catch e As RuntimeException
		      // Silent fallback if bomb sound fails
		    End Try

		    // Distribute energy to adjacent cells
		    Var adjacentCells() As Dictionary

		    Var upCell As New Dictionary
		    upCell.Value("row") = row-1
		    upCell.Value("column") = column
		    adjacentCells.Add(upCell)  // Up

		    Var downCell As New Dictionary
		    downCell.Value("row") = row+1
		    downCell.Value("column") = column
		    adjacentCells.Add(downCell)  // Down

		    Var leftCell As New Dictionary
		    leftCell.Value("row") = row
		    leftCell.Value("column") = column-1
		    adjacentCells.Add(leftCell)  // Left

		    Var rightCell As New Dictionary
		    rightCell.Value("row") = row
		    rightCell.Value("column") = column+1
		    adjacentCells.Add(rightCell)  // Right

		    For Each cellInfo As Dictionary In adjacentCells
		      Var adjRow As Integer = cellInfo.Value("row")
		      Var adjColumn As Integer = cellInfo.Value("column")

		      If IsValidPosition(adjRow, adjColumn) Then
		        mGrid(GetGridIndex(adjRow, adjColumn)).ReceiveEnergy(1)
		      End If
		    Next

		    // Explosion triggered

		  Catch e As RuntimeException
		    // Error triggering explosion
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(deltaTime As Double)
		  // Update grid state and animations
		  Try
		    mIsAnimating = False

		    // Update all cells
		    For row As Integer = 0 To mGridSize - 1
		      For column As Integer = 0 To mGridSize - 1
		        mGrid(GetGridIndex(row, column)).Update(deltaTime)
		        If mGrid(GetGridIndex(row, column)).IsExploding() Then
		          mIsAnimating = True
		        End If
		      Next
		    Next

		    // Check for chain explosions
		    If Not mIsAnimating Then
		      Var chainExplosions As Integer = CheckExplosionChain()
		      If chainExplosions > 0 Then
		        mIsAnimating = True
		      End If
		    End If

		  Catch e As RuntimeException
		    // Error in update cycle
		  End Try
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mExplosionCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGrid() As ChainReactionOrb
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGridSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsAnimating As Boolean
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