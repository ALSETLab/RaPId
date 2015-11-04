# iTesla RaPId
iTesla RaPId  (a recursive acronym for "Rapid Parameter Identification") utilizes different optimization and simulation technologies to provide a framework for model validation and calibration of any kind of dynamical systems, but specifically catered to power systems. The foundation of RaPId is MATLAB/Simulink which is necessary for processing the available measurements and for the simulation of the Modelica model within the MATLAB/Simulink platform. Simulation of the Modelica model is carried out using the FMI Toolbox for MATLAB. Within the MATLAB environment, RaPId provides the user with different functionalities, such as the set-up of an optimization problem, access to different solvers to simulate the model, and automates a parameter optimization process (or “calibration”) so that the model is not only validated (i.e. satisfies the error allowed in an objective function) but also calibrated (i.e. the error of the objective function is minimized by finding optimal parameters). 

The user is provided with a Graphical User Interface (GUI) which he can use to set-up the model validation and calibration problem. More advanced users, such as researchers, can take benefit of the modular design of RaPId which allows the use of the command line interface via MATLAB scripts, the inclusion of dedicated optimization routines (by extending RaPId's source code), and the formulation of different optimization problems.

RaPId has been designed with the researcher in mind: to give maximum flexibility and efficiency to develop methods and derive tools for model validation, calibration and correction. The spirit of RaPId is that other researchers will use it and contribute to its features – as such, RaPId is distributed as an Open Source Software.

What RaPId becomes in the future is up to you, the researcher or engineer that needs freedom and flexibility to put your creativity in action, and if RaPId makes this happen, please share it with all of us by contributing with your developments!

## Citing iTesla RaPId in Publications
If you use RaPId in your work or research, all we ask you in exchange is that you cite the following papers. You are also welcome to submit your contributions (modifications to RaPId or examples) using GIT.

- Luigi Vanfretti, Maxime Baudette, Achour Amazouz, Tetiana Bogodorova, Tin Rabuzin, Jan Lavenius and Francisco Gomez Lopez, "RaPId: A modular and extensible toolbox for parameter estimation of Modelica and FMI-complaint models - Part I: Software Architecture and Development," to be submitted, Elsevier Software X, 2015.
- L. Vanfretti, T. Bogodorova, and M. Baudette, “Power System Model Identification Exploiting the Modelica Language and FMI Technologies,” 2014 IEEE International Conference on Intelligent Energy and Power Systems, June 2-6, 2014, Kyiv, Ukraine.
- L. Vanfretti, T. Bogodorova, and M. Baudette, “A Modelica Power System Component Library for Model Validation and Parameter Identification,” 10th International Modelica Conference 2014, Lund, Sweden, Mar. 10 – 12, 2014.

## Software requirements (dependencies):
Here is compiled a list of the required software packages to run the toolbox. 
- Matlab R2011b to R2014b ([MathWorks](http://se.mathworks.com/products/matlab/))
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

## Creating FMUs from Modelica Power System Models using the iTesla Power Systems Modelica Library (iPSL)
RaPId can be used with any FMU generated from an [FMI Compliant tool](https://www.fmi-standard.org/tools).

However, the development of RaPId was carried out in parallel to the development of the iPSL, also within the iTesla project, to be able to validate and calibrate power system models.

To create FMUs for power system models you can use a [Modelica tool of your choice](https://modelica.org/tools) capable of generating FMUs. FMU generation with RaPId has been tested using [JModelica](http://www.jmodelica.org/), [OpenModelica](https://www.openmodelica.org/) and [Dymola](http://www.3ds.com/products-services/catia/products/dymola).

If you would like to use Modelica to generate FMUs containing power system models, you can use the [iPSL](https://github.com/itesla/ipsl). Several of the examples in RaPId where developed using the iPSL.

## Acknowledgements
The initial development of iTesla RaPId was possible through the [iTesla](http://www.itesla-project.eu/) project funded by the European Commission through the FP7. 
The original development team at KTH SmarTS Lab was also supported by [Statnett SF](http://www.statnett.no/) (the Norwegian power grid operator), the NER-funded project [STRONgrid](http://www.nordicenergy.org/project/smart-transmission-grid-operation-and-control/), and the [STandUP for Energy collaboration initiative](http://www.standupforenergy.se/).

## Dedication of this OSS Release (by Luigi Vanfretti - RaPId's Original Dev. Team Leader)
See [Full Statement on the Wiki.](https://github.com/SmarTS-Lab/iTesla_RaPId/wiki#dedication-of-this-oss-release-by-luigi-vanfretti---rapids-original-dev-team-leader)

## No Warranty
<Rapid Parameter Identification is a toolbox for automated parameter identification>

Copyright 2015 Luigi Vanfretti, Achour Amazouz, Maxime Baudette, 
Tetiana Bogodorova, Jan Lavenius, Tin Rabuzin, Giuseppe Laera, 
Francisco Gomez-Lopez

The authors can be contacted by email: luigiv at kth dot se

This package is part of Rapid Parameter Identification ("RaPId") .

RaPId is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

RaPId is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with RaPId.  If not, see <http://www.gnu.org/licenses/>.


