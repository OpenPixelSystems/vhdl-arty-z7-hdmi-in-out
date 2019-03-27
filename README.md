# Arty Z7 HDMI In Out

This repo contains a working, tested implementation of digilents HDMI IN/OUT project. It uses an external ip repo for the input and output towards HDMI which was not working in the Digilent example on Vivado 2018.3.

The project is made to work with an iMX6 and OV5640 Camera as input which has some interesting qwerks. To have simple HDMI In/Out one can just remove the OV5640_modder from the design.
