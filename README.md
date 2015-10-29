# iTesla_RaPId

## Software requirements (dependencies):
Here is compiled a list of the required software packages to run the toolbox. 
- Matlab R2011b or above ([MathWorks](http://se.mathworks.com/products/matlab/))
- Simulink ([MathWorks](http://se.mathworks.com/products/matlab/))
- Matlab Toolboxes:
  * Optimization Toolbox
  * Global Optimization Toolbox
  * Statistics Toolbox
  * Signal Processing Toolbox
  * Image Processing Toolbox
- FMI Toolbox ([Modelon](http://www.modelon.com/products/fmi-toolbox-for-matlab/))

## Installation: 
Provided that all the software required have been installed on your machine, the installation has been automated with an installation script.

The first step of the installation is to procure the RaPId toolbox:
- You can download the .zip file from the GitHub homepage and unzip the file in any directory on the computer
- You can clone the repository on your local machine

The rest of the installation will be executed in Matlab:
- Launch Matlab and change the working directory to the /Sources/ sub-folder of the RaPId toolbox
- Run the 'setup_rapid.m' script
- Check that the dependency check didn't prompt any warning
- The GUI of the toolbox will be launched upon successful installation

## Using the toolbox:
The best way to get familiar with the toolbox is to refer to the examples provided. Each example is delivered in a separate folder in the /Examples/ folder, containing the necessary elements to use the toolbox:
- the FMU containing the model to optimize
- the Simulink model providing a wrapper for the FMU
- a .mat file containing the reference measurements 
- a .mat file named container, containing all the settings of the experiments

To load an example, click on the 'load container' button and select an example's container. After successful loading, you can simply click on 'Run Optimization' and the toolbox will run the optimization process. 

To build your own experiments, the best practice is to work in the /Examples/work_dir/ directory (it is ignored by GIT). You can start by copying the files of one of the examples, replace with your own FMU, load the copied container and modify the appropriate settings to suite your experiment. 
Don't forget to save your container, after your modifications!

More details is available in the Documentation. 
