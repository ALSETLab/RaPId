[![DOI](https://zenodo.org/badge/44382864.svg)](https://zenodo.org/badge/latestdoi/44382864)

# RaPId

## <div id="abstract">Abstract
**RaPId**  (a recursive acronym for "Rapid Parameter Identification") utilizes different optimization and simulation technologies to provide a framework for model validation and calibration of any kind of dynamical systems, but specifically catered to power systems. A quick overview of RaPId can be found [here](https://www.dropbox.com/s/hxu7t77y7hor54j/2015_LV_iTeslaNov_Workshop_Rapid.pdf?dl=0).
</div>

## <div id="contents">Contents
1. [Abstract](#abstract)
2. [Contents](#contents)
3. [Quick Download: Release](#release)
4. [Contributing](#contribute)
5. [RaPId Introduction](#intro)
6. [Cite us in your Publications](#cite)
7. [RaPId - Quick Start](#quickstart)
  1. [Demo videos](#demos)
  2. [Software requirements](#reqs)
  3. [Installation](#install)
  4. [Using the toolbox](#usage)
  5. [Creating FMUs](#createfmu)
  6. [Creating FMUs for Power System Models](#createpowerfmu)
8. [Acknowledgements](#acknowledgements)
9. [Dedication](#dedi)
10. [No Warranty](#nowarranty)
</div>

## <div id="release">Quick Download: Release

- If you are not familiar using GIT to work with repositories, and all you want is to check out RaPId, please go directly to the [Release Tab](https://github.com/SmarTS-Lab/iTesla_RaPId/releases).
</div>

## <div id="contribute">Contributing
- Reporting Bugs: please use the Issues tab to report bugs.
- If you are familiar with GIT, and want to be involved in the development (from bug fixes, to anything else!), please clone the repository and use GIT to contribute.
- Contributions: Via Pull Requests.
</div>

## <div id="intro">RaPId - Introduction
RaPId  (a recursive acronym for "Rapid Parameter Identification") utilizes different optimization and simulation technologies to provide a framework for model validation and calibration of any kind of dynamical systems, but specifically catered to power systems. The foundation of RaPId is MATLAB/Simulink which is necessary for processing the available measurements and for the simulation of the Modelica model within the MATLAB/Simulink platform. Simulation of the Modelica model is carried out using the FMI Toolbox for MATLAB. Within the MATLAB environment, RaPId provides the user with different functionalities, such as the set-up of an optimization problem, access to different solvers to simulate the model, and automates a parameter optimization process (or “calibration”) so that the model is not only validated (i.e. satisfies the error allowed in an objective function) but also calibrated (i.e. the error of the objective function is minimized by finding optimal parameters).

The user is provided with a Graphical User Interface (GUI) which he can use to set-up the model validation and calibration problem. More advanced users, such as researchers, can take benefit of the modular design of RaPId which allows the use of the command line interface via MATLAB scripts, the inclusion of dedicated optimization routines (by extending RaPId's source code), and the formulation of different optimization problems.

RaPId has been designed with the researcher in mind: to give maximum flexibility and efficiency to develop methods and derive tools for model validation, calibration and correction. The spirit of RaPId is that other researchers will use it and contribute to its features – as such, RaPId is distributed as an Open Source Software.

What RaPId becomes in the future is up to you, the researcher or engineer that needs freedom and flexibility to put your creativity in action, and if RaPId makes this happen, please share it with all of us by contributing with your developments!
</div>

## <div id="cite">RaPId - Cite us in your Publications
If you use RaPId in your work or research, all we ask you in exchange is that you cite the following papers. You are also welcome to submit your contributions (modifications to RaPId or examples) using GIT.

If you only have space for one publication, our prefered citation is the following:

- Luigi Vanfretti, Maxime Baudette, Achour Amazouz, Tetiana Bogodorova, Tin Rabuzin, Jan Lavenius, Francisco José Goméz-López, RaPId: A modular and extensible toolbox for parameter estimation of Modelica and FMI compliant models, SoftwareX, Available online 25 August 2016, ISSN 2352-7110, http://dx.doi.org/10.1016/j.softx.2016.07.004.
Download paper: [here](http://www.sciencedirect.com/science/article/pii/S235271101630019X)

If you only have space for additional publications, you can also cite the following papers:
- L. Vanfretti, T. Bogodorova, and M. Baudette, “Power System Model Identification Exploiting the Modelica Language and FMI Technologies,” 2014 IEEE International Conference on Intelligent Energy and Power Systems, June 2-6, 2014, Kyiv, Ukraine. Download paper [here](http://ieeexplore.ieee.org/xpl/articleDetails.jsp?arnumber=6874164).
- L. Vanfretti, T. Bogodorova, and M. Baudette, “A Modelica Power System Component Library for Model Validation and Parameter Identification,” 10th International Modelica Conference 2014, Lund, Sweden, Mar. 10 – 12, 2014. Download paper [here](https://www.modelica.org/events/modelica2014/proceedings/html/submissions/ECP140961195_VanfrettiBogodorovaBaudette.pdf).
</div>

## <div id="quickstart"> RaPId - Quick Start </div>
### <div id="demos"> Demo Videos
To see RaPId in action, you can find demonstration videos on Youtube:

1. Demonstrating basic usage of RaPId:
  - [Using the GUI](https://www.youtube.com/watch?v=e7OkVEtcz6A)
  - [Using the CLI](https://www.youtube.com/watch?v=4qrPASIWdiY).

2. Using RaPId to identify Power System Parameters
  - [Using RaPId to identify exciter parameters in the MOSTAR power plant:](https://www.youtube.com/watch?v=X8X89l1HBjo)

3. Advanced features (Future! Release: TBA)
  - Extended functionalities of RaPId for small-signal (linearized model) and time-domain (non-linear time domain) power system inter-area electromechanical mode model validation and calibration: [Inter-Area Mode Model-Validation](https://www.youtube.com/watch?v=5s34tjT9Cwk)

**Note:**  RaPId is continuously evolving, thus the GUI and source code is subject to change (usually improvements) compared to what is depicted in the videos.
</div>

### <div id="reqs"> Software requirements (dependencies):
Here is compiled a list of the required software packages to run the toolbox.
- Matlab R2016b ([MathWorks](http://mathworks.com/products/matlab/)). R2018b will be supported and replace R2016b when the FMI Toolbox adds support for that version.
- Simulink ([MathWorks](http://mathworks.com/products/matlab/))
- Matlab Toolboxes:
  * Optimization Toolbox
  * Global Optimization Toolbox
  * Statistics Toolbox
  * Signal Processing Toolbox
- FMI Toolbox v2.6.x and above ([Modelon](http://www.modelon.com/products/fmi-toolbox-for-matlab/))
  

- Note on Operating Systems: 
    - Testing for the current version of RaPId has only been carried out using Windows 10 (64-bit) 
    - While the software should work in other operating systems supporting MATLAB/Simulink, the FMI Toolbox and with FMUs exported for that platform, this variants have not been tested.
    - In the future, testing will be carried for Ubuntu (LTS versions 16 and 18), and specific versions of Red Hat (TBD).
    - MAC OS cannot be supported natively, as the FMI Toolbox is not supported in Mac OS.

</div>

### <div id="install"> Installation:
Provided that all the software required have been installed on your machine, the installation has been automated with an installation script.

The first step of the installation is to procure the RaPId toolbox:
- You can download the .zip file from the GitHub homepage and unzip the file in any directory on the computer
- You can clone the repository on your local machine

The rest of the installation will be executed in Matlab:
1. Launch Matlab and change the working directory to the **./rapid/** folder of the RaPId toolbox.
2. Run the **'setupRapid.m'** script located in this sub-folder.
3. Check that the dependency check didn't prompt any warning.
4. The GUI of the toolbox will be launched upon successful installation.
</div>

### <div id="usage"> Using the toolbox:
The best way to get familiar with the toolbox is to refer to the examples provided. Each example is delivered in a separate folder in the **./Examples/** folder, containing the necessary elements to use the toolbox:
- the FMU containing the model to optimize
- the Simulink model providing a wrapper for the FMU
- a .mat file containing the reference measurements
- a .mat file (typically named **'container.mdl'**), containing all the settings of the experiments

To load an example, click on the 'load container' button and select an example's container. After successful loading, you can simply click on 'Run Optimization' and the toolbox will run the optimization process.

To build your own experiments, the best practice is to work in the **./Examples/work_dir/** directory (it is ignored by GIT). You can start by copying the files of one of the examples, replace with your own FMU, load the copied container and modify the appropriate settings to suite your experiment.

Don't forget to save your container, after your modifications!

</div>

### <div id="createfmu"> Creating FMUs
In principle, RaPId be used with any FMU generated from an [FMI Compliant tool](https://www.fmi-standard.org/tools). However, because RaPId depends on the FMI Toolbox for MATLAB/Simulink, the user needs to check if their tool has been supported and/or tested by the FMI Toolbox developers, [Modelon](http://www.modelon.com/products/supported-tools/).
</div>

### <div id="createpowerfmu"> Creating FMUs for Power System Models
The development of RaPId was carried out in parallel to the development of a Modelica library for power networks to be able to validate and calibrate power system models. Currently, only the Modelica OpenIPSL library is recommended: [https://openipsl.org](https://openipsl.org)

To create FMUs for power system models you can use a [Modelica tool of your choice](https://modelica.org/tools) capable of generating FMUs. FMU generation with RaPId has been tested using [JModelica](http://www.jmodelica.org/) and [Dymola](http://www.3ds.com/products-services/catia/products/dymola).

If you would like to use Modelica to generate FMUs containing power system models, you can use the [OpenIPSL](https://github.com/SmarTS-Lab/OpenIPSL). Several of the examples in RaPId where developed using the OpenIPSL.
</div>

## <div id="acknowledgements">Acknowledgements
The initial development of RaPId was possible through the [iTesla](http://www.itesla-project.eu/) project funded by the European Commission through the FP7 program. 
</div>

## <div id="dedi">Dedication
To the memory of Jan Ove Gjerde.
</div>

## <div id="nowarranty">No Warranty
><Rapid Parameter Identification is a toolbox for automated parameter identification>
>
>Copyright 2015-2018 Luigi Vanfretti, Achour Amazouz, Maxime Baudette,
>Tetiana Bogodorova, Jan Lavenius, Tin Rabuzin, Giuseppe Laera,
>Francisco Gomez-Lopez
>
>The authors can be contacted by email: luigi.vanfretti@gmail.com
>
>This package is part of Rapid Parameter Identification ("RaPId") .
>
>RaPId is free software: you can redistribute it and/or modify
>it under the terms of the GNU Lesser General Public License as published by
>the Free Software Foundation, either version 3 of the License, or
>(at your option) any later version.
>
RaPId is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.
>
You should have received a copy of the GNU Lesser General Public License
along with RaPId.  If not, see <http://www.gnu.org/licenses/>.

</div>
