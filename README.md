# Arty Z7 HDMI In Out

This repo contains a working, tested implementation of digilents HDMI IN/OUT project. It uses an external ip repo for the input and output towards HDMI which was not working in the Digilent example on Vivado 2018.3.

The project is made to work with an iMX6 and OV5640 Camera as input which has some interesting qwerks. To have simple HDMI In/Out one can just remove the OV5640_modder from the design.

## Building the project

This project is structured to be used with our generic [build scripts](https://github.com/OpenPixelSystems/makefile-vivado-project). 

```bash
git clone git@github.com:OpenPixelSystems/makefile-vivado-project.git
git clone git@github.com:OpenPixelSystems/arty-z7-hdmi-in-out.git
cd makefile-vivado-project
REPO_DIR=<ip_dir> ORIGIN_DIR=../arty-z7-hdmi-in-out/vivado_proj/ make all
```
