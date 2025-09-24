#tag DesktopWindow
Begin DesktopWindow Window1
   Backdrop        =   0
   BackgroundColor =   &c404040
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   True
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   720
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   720
   MaximumWidth    =   1280
   MenuBar         =   705007615
   MenuBarVisible  =   True
   MinimumHeight   =   720
   MinimumWidth    =   1280
   Resizeable      =   False
   Title           =   "Chain Reaction Simulator"
   Type            =   0
   Visible         =   True
   Width           =   1280
   Begin DesktopCanvas GameCanvas
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   True
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   720
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   True
      Visible         =   True
      Width           =   1280
   End
   Begin Timer GameTimer
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   16
      RunMode         =   2
      Scope           =   0
      TabPanelIndex   =   0
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Closing()
		  // Clean shutdown
		  GameTimer.Enabled = False
		  AppTemplate.ShutdownApplication()
		  mCanvasManager = Nil
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(key As String) As Boolean
		  // Route keyboard input to current scene
		  Var inputData As New Dictionary
		  inputData.Value("keyPressed") = key

		  System.DebugLog("Key pressed: " + key + " (ASCII: " + Str(Asc(key)) + ")")
		  Router.HandleInputForCurrentScene(inputData)
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub Opening()
		  // Initialize the Chain Reaction Simulator using Shared Foundations
		  Try
		    // Initialize shared systems
		    AppTemplate.InitializeApplication(Self)
		    
		    // Register game scenes
		    Router.RegisterScene(Router.eGameScene.MainMenu, New ChainReactionMenuScene)
		    Router.RegisterScene(Router.eGameScene.HowToPlay, New ChainReactionHowToPlayScene)
		    Router.RegisterScene(Router.eGameScene.GamePlay, New ChainReactionGameScene)
		    Router.RegisterScene(Router.eGameScene.Results, New ChainReactionResultsScene)
		    
		    // Initialize canvas manager
		    mCanvasManager = New CanvasManager(GameCanvas)
		    
		    // Switch to main menu
		    Router.SwitchToScene(Router.eGameScene.MainMenu)
		    
		    // Start the game loop timer
		    GameTimer.Enabled = True
		    
		    System.DebugLog("Chain Reaction Simulator initialized successfully")
		    
		  Catch e As RuntimeException
		    System.DebugLog("Chain Reaction Simulator initialization failed: " + e.Message)
		    MessageBox("Failed to initialize game: " + e.Message)
		  End Try
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h21
		Private mCanvasManager As CanvasManager
	#tag EndProperty


#tag EndWindowCode

#tag Events GameCanvas
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  // Render current frame using framework
		  If mCanvasManager <> Nil Then
		    mCanvasManager.BeginFrame()

		    Var backBufferGraphics As Graphics = mCanvasManager.GetBackBufferGraphics()
		    If backBufferGraphics <> Nil Then
		      AppTemplate.RenderFrame(backBufferGraphics)
		    End If

		    mCanvasManager.EndFrame()

		    // Draw back buffer to canvas
		    Var backBuffer As Picture = mCanvasManager.GetBackBuffer()
		    If backBuffer <> Nil Then
		      g.DrawPicture(backBuffer, 0, 0)
		    End If
		  Else
		    // Fallback rendering
		    AppTemplate.RenderFrame(g)
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  // Route mouse input to current scene
		  Var inputData As New Dictionary
		  inputData.Value("mouseClicked") = True
		  inputData.Value("mouseX") = x
		  inputData.Value("mouseY") = y

		  Router.HandleInputForCurrentScene(inputData)
		  Return True
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events GameTimer
	#tag Event
		Sub Action()
		  // Main game loop - 60 FPS target
		  Var deltaTime As Double = AppTemplate.CalculateDeltaTime()
		  AppTemplate.UpdateFrame(deltaTime)
		  GameCanvas.Refresh(False) // Trigger Paint event
		End Sub
	#tag EndEvent
#tag EndEvents
