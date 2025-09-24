#tag Class
Protected Class ChainReactionOrb
	#tag Method, Flags = &h0
		Function CanExplode() As Boolean
		  // Check if orb can explode (has reached critical mass)
		  Return mCount >= ChainReactionConstants.kMaxOrbsPerCell
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize empty orb
		  mCount = 0
		  mState = ChainReactionConstants.eOrbState.EmptyCell
		  mAnimationTime = 0.0
		  mPulseIntensity = 1.0
		  mIsExploding = False
		  mExplosionTime = 0.0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(initialCount As Integer)
		  // Initialize orb with specific count
		  Constructor()
		  SetCount(initialCount)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Draw(g As Graphics, x As Integer, y As Integer, cellSize As Integer)
		  // Draw orb based on current state
		  Try
		    If mState = ChainReactionConstants.eOrbState.EmptyCell Then Return

		    Var centerX As Integer = x + cellSize / 2
		    Var centerY As Integer = y + cellSize / 2
		    Var orbRadius As Integer = 8

		    // Apply pulsing animation for critical orbs
		    If mState = ChainReactionConstants.eOrbState.Critical Then
		      orbRadius = orbRadius * mPulseIntensity
		    End If

		    // Apply explosion scaling
		    If mIsExploding Then
		      Var explosionScale As Double = mExplosionTime / ChainReactionConstants.kExplosionDuration
		      orbRadius = orbRadius * (1.0 + explosionScale * 2.0)
		    End If

		    // Get orb color based on state
		    g.DrawingColor = GetOrbColor()

		    Select Case mCount
		    Case 1
		      // Draw single orb in center
		      g.FillOval(centerX - orbRadius, centerY - orbRadius, orbRadius * 2, orbRadius * 2)

		    Case 2
		      // Draw two orbs side by side
		      g.FillOval(centerX - orbRadius - 6, centerY - orbRadius, orbRadius * 2, orbRadius * 2)
		      g.FillOval(centerX + 6 - orbRadius, centerY - orbRadius, orbRadius * 2, orbRadius * 2)

		    Case 3
		      // Draw three orbs in triangle
		      g.FillOval(centerX - orbRadius, centerY - orbRadius - 6, orbRadius * 2, orbRadius * 2)
		      g.FillOval(centerX - orbRadius - 6, centerY + 3 - orbRadius, orbRadius * 2, orbRadius * 2)
		      g.FillOval(centerX + 6 - orbRadius, centerY + 3 - orbRadius, orbRadius * 2, orbRadius * 2)

		    Case Else
		      // Draw four orbs in square formation (critical)
		      g.FillOval(centerX - orbRadius - 6, centerY - orbRadius - 6, orbRadius * 2, orbRadius * 2)
		      g.FillOval(centerX + 6 - orbRadius, centerY - orbRadius - 6, orbRadius * 2, orbRadius * 2)
		      g.FillOval(centerX - orbRadius - 6, centerY + 6 - orbRadius, orbRadius * 2, orbRadius * 2)
		      g.FillOval(centerX + 6 - orbRadius, centerY + 6 - orbRadius, orbRadius * 2, orbRadius * 2)
		    End Select

		    // Draw glowing effect for critical orbs
		    If mState = ChainReactionConstants.eOrbState.Critical Then
		      DrawGlowEffect(g, centerX, centerY, orbRadius)
		    End If

		  Catch e As RuntimeException
		    // Error in drawing routine
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawGlowEffect(g As Graphics, centerX As Integer, centerY As Integer, radius As Integer)
		  // Draw glowing effect around critical orbs
		  For i As Integer = 1 To 3
		    Var glowRadius As Integer = radius + (i * 4)
		    Var alpha As Integer = 60 - (i * 15)
		    g.DrawingColor = Color.RGB(255, 255, 0, alpha) // Semi-transparent yellow
		    g.PenSize = 2
		    g.DrawOval(centerX - glowRadius, centerY - glowRadius, glowRadius * 2, glowRadius * 2)
		  Next
		  g.PenSize = 1 // Reset pen size
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Explode() As Integer
		  // Trigger explosion and return energy released
		  If Not CanExplode() Then Return 0

		  Var energyReleased As Integer = mCount
		  mState = ChainReactionConstants.eOrbState.Exploding
		  mIsExploding = True
		  mExplosionTime = 0.0

		  // Reset count to empty after explosion starts
		  mCount = 0

		  Return energyReleased
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCount() As Integer
		  // Get current orb count
		  Return mCount
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetOrbColor() As Color
		  // Get color based on orb state
		  Select Case mState
		  Case ChainReactionConstants.eOrbState.EmptyCell
		    Return Color.RGB(0, 0, 0, 0) // Transparent

		  Case ChainReactionConstants.eOrbState.OneOrb
		    Return Color.RGB(100, 200, 100) // Light green

		  Case ChainReactionConstants.eOrbState.TwoOrbs
		    Return Color.RGB(100, 150, 255) // Light blue

		  Case ChainReactionConstants.eOrbState.ThreeOrbs
		    Return Color.RGB(255, 150, 100) // Light orange

		  Case ChainReactionConstants.eOrbState.Critical
		    Return Color.RGB(255, 50, 50) // Bright red

		  Case ChainReactionConstants.eOrbState.Exploding
		    Return Color.RGB(255, 255, 100) // Bright yellow

		  Else
		    Return Color.Gray
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetState() As ChainReactionConstants.eOrbState
		  // Get current orb state
		  Return mState
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsEmpty() As Boolean
		  // Check if orb is empty
		  Return mCount = 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsExploding() As Boolean
		  // Check if orb is currently exploding
		  Return mIsExploding
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReceiveEnergy(energy As Integer)
		  // Add energy (orbs) to this cell
		  If mIsExploding Then Return // Can't add to exploding orb

		  mCount = mCount + energy
		  UpdateState()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  // Reset orb to empty state
		  mCount = 0
		  mState = ChainReactionConstants.eOrbState.EmptyCell
		  mAnimationTime = 0.0
		  mPulseIntensity = 1.0
		  mIsExploding = False
		  mExplosionTime = 0.0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCount(newCount As Integer)
		  // Set orb count directly
		  mCount = Max(0, newCount)
		  UpdateState()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(deltaTime As Double)
		  // Update orb animations and state
		  Try
		    mAnimationTime = mAnimationTime + deltaTime

		    // Update pulsing animation for critical orbs
		    If mState = ChainReactionConstants.eOrbState.Critical Then
		      mPulseIntensity = 1.0 + Sin(mAnimationTime * 10.0) * 0.2
		    End If

		    // Update explosion animation
		    If mIsExploding Then
		      mExplosionTime = mExplosionTime + deltaTime
		      If mExplosionTime >= ChainReactionConstants.kExplosionDuration Then
		        // Explosion finished
		        mIsExploding = False
		        mExplosionTime = 0.0
		        If mCount = 0 Then
		          mState = ChainReactionConstants.eOrbState.EmptyCell
		        End If
		      End If
		    End If

		  Catch e As RuntimeException
		    // Error in update cycle
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateState()
		  // Update orb state based on count
		  If mIsExploding Then Return // Don't change state during explosion

		  Select Case mCount
		  Case 0
		    mState = ChainReactionConstants.eOrbState.EmptyCell
		  Case 1
		    mState = ChainReactionConstants.eOrbState.OneOrb
		  Case 2
		    mState = ChainReactionConstants.eOrbState.TwoOrbs
		  Case 3
		    mState = ChainReactionConstants.eOrbState.ThreeOrbs
		  Case Else
		    mState = ChainReactionConstants.eOrbState.Critical
		  End Select
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mAnimationTime As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mExplosionTime As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsExploding As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPulseIntensity As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mState As ChainReactionConstants.eOrbState
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