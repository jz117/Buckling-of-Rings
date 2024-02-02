# Workflow Instructions

__1. Simulate Ring Deformation__
	* __Script Name:__ SimulateRing.m
	* __Description:__ This script simulates the deformation of a ring under a specified uniform external pressure (P), applied normally to all grid points on the ring's surface. The user must set the ring dimensions, the external pressure value, the final simulation time (tf), and the number of time steps (M).
	* __Dependencies:__ Relies on SystemOfEqns.m for the underlying equations of motion.
	* __Termination Condition:__ The simulation halts when the ring's inner walls contact or cross each other. Detection is based on a defined radius around each grid point; if a non-adjacent grid point enters this radius, it's considered a contact event.
	* __Output:__ A 3D plot visualizes the deformation over time, with color gradations from blue to yellow (blue -> green -> orange -> yellow) indicating progression from the start to the end of the simulation. The axes shown are x, y and t.

__2. Plot Selected Ring Conformation__
	* __Script Name:__ PlotSelection.m
	* __Description:__ Allows the user to select a specific time step (frame) from the simulation for detailed examination. The selected frame (extracted conformation) should be less than or equal to the final iteration and likely less than M.
	* __Output:__ Generates a 2D plot of the ring conformation at the chosen time step. All prior conformations leading up to the specified frame are also displayed.

__3. Reverse Ring Deformation__
	* __Script Name:__ ReverseRing.m
	* __Description:__ Starting from the extracted ring conformation, this script applies an inverse pressure (-P) to simulate the ring returning to its original shape. Forces and velocities experienced by the extracted conformation are reset to their initial states.
	* __Dependencies and Termination Condition:__ Uses SystemOfEqns.m for calculations, with a stopping criterion based on the ring's diameter through CalculateEffectiveDiameter.m. The script concludes once the ring's diameter is within 10\% of its original, indicating a return to a roughly circular shape.
	* __Output:__ Displays a 3D plot showing the reversal process over time, with the time axis included to illustrate progression.

__4. Plot Reverse Process__
	* __Script Name:__ PlotReverse.m
	* __Description:__ Similar to PlotSelection.m, this script enables the user to choose a specific frame from the reverse deformation process to visualize in 2D and all prior frames leading up to the selected frame are displayed as well.