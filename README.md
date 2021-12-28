# ECSE597-CircuitSimulation
 This repository contains the code written to complete the assignments for a graduate circuit simulation and design course, ECSE597. 
 
#### @ Author: Vasily G. Piccone
#### Tools used: MATLAB

## Assignment 1
The code written for this assignment includes the component stamps for inductors (**ind.m**), voltage-controlled voltage sources (**vcvs.m**), and voltage-controlled current sources (**vccs.m**). The program **fsolve.m** obtains the AC steady-state frequency-domain solution of a linear circuit, and **dcsolve.m** uses nljacobian.m to obtain the DC solution of non-linear circuits containing resistive and storage elements.

## Assignment 2
The code written for this assignment includes the functions **transient_beuler.m**, **transient_trapez.m**, **transient_feuler.m** and **nl_transient_beuler.m**. The first three functions solve for the transient response of a circuit described via MNA equations using the _backward Euler method_, _trapezoidal rule_, and _forward Euler method_ for linear systems of ordinary differential equations. The **nl_transient_beuler.m** function uses the _Newton-Raphson method_ to solve the resulting system of non-linear algebraic equations obtained at each time step of the backward Euler method. This function was used to analyze the transient behaviour of non-linear circuits, namely circuits containing diodes, resistive elements and storage elements.

## Assignment 3
The code written for this assignment includes several functions. The **dcsolvealpha.m**, which solves the MNA equations given a value alpha, by which the b vector (the vector containing the independent souce terms, or forcing functions) is scaled. Alpha holds a value between 0 and 1. The **dcsolvecont.m** function uses the continuation method to solve the MNA equations, where **dcsolvealpha.m** is used to solve the circuit with increasing values of alpha. The **f_vect.m** and **nlJacobian.m** functions from the previous assignments were modified to account for the addition of BJTs to the circuit models using the _Ebers-Moll model_. Finally, the nlACresponse.m function was written to solve for the AC response of non-linear circuits and was tested using the **BJT_CE.m** testbench.
