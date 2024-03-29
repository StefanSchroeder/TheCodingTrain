# TheCodingTrain

## Code Challenges for TheCodingTrain.com implemented in Vlang

## Setup

I am using vim and Nixos.

To enter a development shell, I run

    nix-shell -p xorg.libX11 xorg.libXfixes xorg.libXi xorg.libXext xorg.libXcursor libGL openssl zlib

Compile v from source as documented here: https://github.com/vlang/v

Need to set 

	export VFLAGS='-cc gcc'

NB: Not all the challenges are implemented. In some cases I am referring 
to external solutions. 

## List of Challenges

- [X] CC_001_StarField or here https://github.com/vlang/v/blob/master/examples/gg/stars.v
- [ ] CC_002_MengerSponge
- [X] CC_003_Snake_game solved by https://github.com/vlang/v/tree/master/examples/snek
- [X] CC_004_PurpleRain
- [ ] CC_005_Space_invaders
- [X] CC_006_Mitosis
- [ ] CC_007_SolarSystemGenerator
- [ ] CC_008_SolarSystemGenerator3D
- [ ] CC_009_SolarSystemGenerator3D_texture
- [ ] CC_010_Maze_DFS
- [ ] CC_011_PerlinNoiseTerrain
- [ ] CC_012_LorenzAttractor
- [X] CC_013_ReactionDiffusion
- [ ] CC_014_FractalTree
- [ ] CC_015_FractalTreeArray
- [ ] CC_016_LSystem
- [ ] CC_017_SpaceColonizer
- [ ] CC_018_SpaceColonizer3D/Processing/CC_018_SpaceColonizer3D
- [ ] CC_019_Superellipse
- [ ] CC_020_ClothSimulation
- [X] CC_021_Mandelbrot or here https://github.com/vlang/v/blob/master/examples/gg/mandelbrot.v
- [X] CC_022_JuliaSet
- [ ] CC_023_SuperShape2D
- [ ] CC_024_PerlinNoiseFlowField
- [ ] CC_025_SphereGeometry
- [ ] CC_026_SuperShape3D/Processing/CC_026_SuperShape3D
- [X] CC_027_FireWorks solved by https://github.com/vlang/v/tree/master/examples/fireworks
- [ ] CC_028_MetaBalls
- [ ] CC_029_SmartRockets
- [ ] CC_030_Phyllotaxis
- [ ] CC_031_FlappyBird
- [ ] CC_032.1_agar.io
- [ ] CC_032.2_agar.io_sockets/Node
- [ ] CC_033_poisson_disc
- [ ] CC_034_DLA
- [ ] CC_035.1_TSP
- [ ] CC_035.2_LexicographicOrder
- [ ] CC_035.3_TSP_Lexical
- [ ] CC_035.4_TSP_GA
- [ ] CC_036_Blobby
- [ ] CC_037_diastic
- [ ] CC_038_word_interactor/P5
- [ ] CC_039_madlibs/P5
- [X] CC_040.1_wordcounts or here https://github.com/vlang/v/tree/master/examples/word_counter
- [ ] CC_040.3_tf-idf/P5
- [ ] CC_041_ClappyBird
- [ ] CC_042.1_markov-chain
- [ ] CC_042.2_markov-chain-names
- [ ] CC_043_ContextFreeGrammar
- [ ] CC_044_afinn111SentimentAnalysis
- [ ] CC_045_FirebaseSavingDrawing
- [ ] CC_046_Asteroids
- [ ] CC_047_PixelSorting
- [ ] CC_048_TweetsByMonth
- [ ] CC_049_ObamaMosaic
- [ ] CC_050.1_CirclePackingAnimated
- [ ] CC_050.2_CirclePackingImage
- [ ] CC_051_astar
- [X] CC_052_random_walk
- [ ] CC_053_random_walk_levy
- [ ] CC_054.1_StarPatterns
- [ ] CC_054.2_StarPatterns/P5
- [X] CC_055_Roses
- [ ] CC_056_attraction_repulsion
- [ ] CC_057_Earthquake_Viz
- [ ] CC_058_EarthQuakeViz3D
- [ ] CC_059_Steering_Text_Paths/P5
- [ ] CC_060_Butterfly_Wings
- [ ] CC_061_fractal_spirograph
- [ ] CC_062_plinko
- [ ] CC_063_unikitty_flag
- [ ] CC_064.1_ForwardKinematics
- [ ] CC_064.2_InverseKinematics
- [ ] CC_064.3_InverseKinematics_fixed
- [ ] CC_064.4_InverseKinematics_array
- [ ] CC_065.1_binary_tree
- [ ] CC_065.2_binary_tree_viz
- [ ] CC_066_timer
- [ ] CC_067_Pong
- [ ] CC_068_BFS_kevin_bacon/P5
- [ ] CC_069_steering_evolution
- [ ] CC_070.1_similarity_score/P5
- [ ] CC_070.2_nearest_neighbors/P5
- [ ] CC_070.3_movie_recommender/P5
- [ ] CC_071_minesweeper
- [ ] CC_072_Frogger
- [ ] CC_073_Acrostic/P5
- [X] CC_074_Clock solved by https://github.com/vlang/v/blob/master/examples/clock/clock.v
- [ ] CC_075_Wikipedia
- [ ] CC_076_10PRINT
- [ ] CC_077_Recursion
- [ ] CC_078_Simple_Particle_System
- [ ] CC_079_Number_Guessing_Chatbot
- [ ] CC_080_Voice_Chatbot_with_p5.Speech
- [ ] CC_081.1_Circle_Morphing_Part_1
- [ ] CC_081.2_Circle_Morphing_Part_2
- [ ] CC_082_Image_Chrome_Extension_The_Ex-Kitten-sion
- [ ] CC_083_Chrome_Extension_with_p5js_Sketch
- [ ] CC_084_Word_Definition_Extension/JavaScript
- [X] CC_085_The_Game_of_Life
- [ ] CC_086_beesandbombs
- [ ] CC_087_3D_Knots
- [ ] CC_088_snowfall
- [X] CC_089_langtonsant
- [ ] CC_090_dithering
- [ ] CC_091_snakesladders
- [ ] CC_092_xor
- [X] CC_093_DoublePendulum
- [X] CC_094_2048 solved by https://github.com/vlang/v/tree/master/examples/2048
- [ ] CC_095_Approximating_Pi
- [ ] CC_096_Visualizing_the_Digits_of_Pi
- [ ] CC_097.1_Book_of_Pi_Part_1/Processing/CC_097_1_Book_of_Pi_Part_1
- [ ] CC_097.2_Book_of_Pi_Part_2/Processing/CC_097_2_Book_of_Pi_Part_2
- [ ] CC_098.1_QuadTree
- [ ] CC_098.3_QuadTree_Collisions
- [ ] CC_099_ColorPredictor/P5
- [ ] CC_100.1_NeuroEvolution_FlappyBird
- [ ] CC_100.5_NeuroEvolution_FlappyBird/P5
- [ ] CC_101_MayThe4th
- [ ] CC_102_WaterRipples
- [ ] CC_103_Flames
- [ ] CC_104_tf_linear_regression/P5
- [ ] CC_105_tf_polynomial_regression/P5
- [ ] CC_106_xor_tfjs/P5
- [ ] CC_107_sandpiles
- [ ] CC_108_barnsley_fern
- [ ] CC_109_subscriber_map/P5
- [ ] CC_110.1_recaman
- [ ] CC_110.2_recaman_music/P5
- [ ] CC_111_animated_sprite
- [ ] CC_112_3D_Rendering
- [ ] CC_113_Hypercube
- [ ] CC_114_BubbleSortViz
- [ ] CC_115_Snake_Game_Redux
- [ ] CC_116_Lissajous
- [ ] CC_117_SevenSegmentDisplay
- [ ] CC_118_Mastodon_TreeBot/Node
- [ ] CC_119_Binary_to_Decimal_Conversion
- [ ] CC_120_Bit_Shifting
- [ ] CC_121_Logo_1
- [ ] CC_121_Logo_2
- [ ] CC_122_QuickDraw_1/Node
- [ ] CC_122_QuickDraw_2/P5
- [ ] CC_123_ChaosGame_1
- [ ] CC_123_ChaosGame_2
- [ ] CC_124_Flocking_Boids
- [ ] CC_125_Fourier_Series
- [ ] CC_126_Toothpicks
- [ ] CC_127_Snowflake_Brownian
- [ ] CC_128_SketchRNN_Snowflakes/P5
- [ ] CC_129_Koch_Snowflake
- [ ] CC_130_Fourier_Transform_1
- [ ] CC_130_Fourier_Transform_2/P5
- [ ] CC_130_Fourier_Transform_3
- [ ] CC_131_BouncingDVDLogo
- [ ] CC_132_FluidSimulation
- [ ] CC_133_Times_Tables_Cardioid
- [ ] CC_134_Heart_Curve_1
- [ ] CC_134_Heart_Curve_2
- [ ] CC_135_GIF_Loop
- [ ] CC_136_Polar_Noise_Loop_1
- [ ] CC_136_Polar_Noise_Loop_2
- [ ] CC_137_4D_Noise_Loop
- [ ] CC_138_Angry_Birds/P5
- [ ] CC_139_Pi_Collisions/P5
- [ ] CC_140_Pi_Leibniz
- [ ] CC_141_Mandelbrot_Pi/Processing/CC_141_Mandelbrot_Pi
- [ ] CC_142_Rubiks_Cube_1
- [ ] CC_142_Rubiks_Cube_2/Processing/CC_142_Rubiks_Cube_2
- [ ] CC_142_Rubiks_Cube_3/Processing/CC_142_Rubiks_Cube_3
- [ ] CC_143_QuickSort/P5
- [ ] CC_144_Black_Hole_Newtonian
- [ ] CC_145_Ray_Casting
- [ ] CC_146_Rendering_Ray_Casting
- [ ] CC_147_Chrome_Dinosaur_Game
- [ ] CC_148_Gift_Wrapping
- [ ] CC_149_Tic_Tac_Toe
- [ ] CC_150_Ai_Rainbows_Runway/P5
- [ ] CC_151_Ukulele_Tuner/P5
- [ ] CC_152_RDP_Algorithm
- [ ] CC_153_Interactive_SketchRRN/P5
- [ ] CC_154_Tic_Tac_Toe_Minimax
- [ ] CC_155_Kaleidoscope_Snowflake
- [ ] CC_156_Pi_Digits
- [ ] CC_157_Zoom_Annotations
- [ ] CC_158_Shape_Classifier
- [ ] CC_159_simple_pendulum_simulation
- [ ] CC_160_spring_forces
- [ ] CC_161_pi_from_random
- [ ] CC_162_self_avoiding_walk
- [ ] CC_163_Bezier
- [ ] CC_164_Slitscan/Processing
- [ ] CC_165_Slide_Puzzle
