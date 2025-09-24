#tag Module
Protected Module ChainReactionConstants
	#tag Constant, Name = kBaseScore, Type = Integer, Dynamic = False, Default = \"1000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kCellSize, Type = Integer, Dynamic = False, Default = \"60", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kChainDelayTime, Type = Double, Dynamic = False, Default = \".15", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kChainReactionBonus, Type = Integer, Dynamic = False, Default = \"25", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kLargeChainBonus, Type = Integer, Dynamic = False, Default = \"100", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kExplosionDuration, Type = Double, Dynamic = False, Default = \".3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kGameTitle, Type = String, Dynamic = False, Default = \"Chain Reaction Simulator", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kGridPadding, Type = Integer, Dynamic = False, Default = \"20", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kDefaultGridSize, Type = Integer, Dynamic = False, Default = \"8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kMaxGridSize, Type = Integer, Dynamic = False, Default = \"12", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kMaxOrbsPerCell, Type = Integer, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kMinClicksForPerfect, Type = Integer, Dynamic = False, Default = \"10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kMinGridSize, Type = Integer, Dynamic = False, Default = \"6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kPerfectBonus, Type = Integer, Dynamic = False, Default = \"500", Scope = Public
	#tag EndConstant


	#tag Property, Flags = &h0
		Shared gCurrentDifficulty As eDifficultyLevel = eDifficultyLevel.Medium
	#tag EndProperty


	#tag Enum, Name = eDifficultyLevel, Type = Integer, Flags = &h0
		Easy = 0
		  Medium = 1
		  Hard = 2
		Expert = 3
	#tag EndEnum

	#tag Enum, Name = eLevelStatus, Type = Integer, Flags = &h0
		NotStarted = 0
		  InProgress = 1
		  Completed = 2
		Perfect = 3
	#tag EndEnum

	#tag Enum, Name = eOrbState, Type = Integer, Flags = &h0
		EmptyCell = 0
		  OneOrb = 1
		  TwoOrbs = 2
		  ThreeOrbs = 3
		  Critical = 4
		Exploding = 5
	#tag EndEnum


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
End Module
#tag EndModule
