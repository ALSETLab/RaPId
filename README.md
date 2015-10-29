# iTesla RaPId

## What is iTesla RaPId?
iTesla RaPId  (a recursive acronym for "Rapid Parameter Identification") utilizes different optimization and simulation technologies to provide a framework for model validation and calibration of any kind of dynamical systems, but specifically catered to power systems. The foundation of RaPId is MATLAB/Simulink which is necessary for processing the available measurements and for the simulation of the Modelica model within the MATLAB/Simulink platform. Simulation of the Modelica model is carried out using the FMI Toolbox for MATLAB. Within the MATLAB environment, RaPId provides the user with different functionalities, such as the set-up of an optimization problem, access to different solvers to simulate the model, and automates a parameter optimization process (or “calibration”) so that the model is not only validated (i.e. satisfies the error allowed in an objective function) but also calibrated (i.e. the error of the objective function is minimized by finding optimal parameters). 

The user is provided with a Graphical User Interface (GUI) which he can use to set-up the model validation and calibration problem. More advanced users, such as researchers, can take benefit of the modular design of RaPId which allows the use of the command line interface via MATLAB scripts, the inclusion of dedicated optimization routines (by extending RaPId's source code), and the formulation of different optimization problems.

RaPId has been designed with the researcher in mind: to give maximum flexibility and efficiency to develop methods and derive tools for model validation, calibration and correction. The spirit of RaPId is that other researchers will use it and contribute to its features – as such, RaPId is distributed as an Open Source Software.

What RaPId becomes in the future is up to you, the researcher or engineer that needs freedom and flexibility to put your creativity in action, and if RaPId makes this happen, please share it with all of us by contributing with your developments!

## Citing iTesla RaPId in Publications
If you use RaPId in your work or research, all we ask you in exchange is that you cite the following papers. You are also welcome to submit your contributions (modifications to RaPId or examples) using GIT.

- Luigi Vanfretti, Maxime Baudette, Achour Amazouz, Tetiana Bogodorova, Tin Rabuzin, Jan Lavenius and Francisco Gomez Lopez, "RaPId: A modular and extensible toolbox for parameter estimation of Modelica and FMI-complaint models - Part I: Software Architecture and Development," to be submitted, Elsevier Software X, 2015.
- Modelica Conference Paper (to be added)
- Conference paper in Ukraine (to be added)

## No Warranty
This software is released under the LGPL, see (add link to license here).

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

## Acknowledgements
The initial development of iTesla RaPId was possible through the [iTesla](http://www.itesla-project.eu/) project funded by the European Commission through the FP7. 
The original development team at KTH SmarTS Lab was also supported by [Statnett SF](http://www.statnett.no/) (the Norwegian power grid operator), the NER-funded project [STRONgrid](http://www.nordicenergy.org/project/smart-transmission-grid-operation-and-control/), and the [STandUP for Energy collaboration initiative](http://www.standupforenergy.se/).

## Dedication of this OSS Release (by Luigi Vanfretti - RaPId's Original Dev. Team Leader)
RaPId is the first realization of one of my biggest dreams, to contribute towards the creation of a Free and Open Source Software capable of combining my two true loves (technical one's that is): power system modeling and simulation, and power system dynamic measurements (a.k.a. PMUs). To see RaPId released gives me an inmense sense of gratitude to many people that have made it possible.

The original idea for the development of RaPId sparked in 2008 from a homework assignment in the Optimizations Methods course taught by Prof. Joe H. Chow when I was a graduate student at RPI, Troy, NY. During the same time, I was fairly active in the efforts towards the maintenance of the OSS software PSAT, developed by Prof. Federico Milano.
I dedicate the release of RaPId to both of them, as a token of appreciation for providing gerat inspiration, technical and ethical guidance over the course of my academic career.

However, having an academic career has not really allowed me to spend as much time programming as I would like, RaPId was only possible thanks to different forms of contributions of members of my research lab at KTH SmarTS Lab during the period of 2011 - 2015. Thus, I want to dedicate the release of RaPId to all former, and current, MSc, Research Engineers, PhD and Post-Docs at KTH SmarTS Lab, in part as a small token of gratitude for all their contributions to my career as a "professor", and in part as a fulfillment of my ethical commitment to carry out research that is useful, hopefully, for someone.

Over the course of 2011-2015, I have gone through the biggest challenges in my life, and I have been very lucky to have the support of Statnett SF, and in particular, of the former Director for R&D, Jan Ove Gjerde, who made my participation in iTesla possible. I therefore want to dedicate the release of RaPId to Jan Ove, Statnett SF, and to Norwegian society for giving me and my students the opportunity and economical support to carry out this work.

Finally, if you are reading this lines, I want to dedicate this software to you, the user and potential developer. 
It does not matter who you are and where you come from, if you have the intellectual means, an internet connection and a computer, you can contribute.
As I used to tell my students "I'm just a third world kid from Guatemala - so if I can do 'A', anybody can do 'A' " (which B.T.W. I am), so no matter where you are the future of RaPId is in your hands: take it to great places that I never imagened!

Luigi Vanfretti
October 29, 2015
Oslo, Norway
