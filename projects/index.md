---
layout: default
title: Projects
---

# JCoolC
Continuing a class project during my semester abroad at UC Berkeley I developed a compiler for the [Classroom Object-Oriented Language](http://theory.stanford.edu/~aiken/software/cool/cool.html).
While this compiler works well as a stand-alone tool and is able to compile nearly the complete featureset of the language to Java bytecode, my current goal is to develop a simple online IDE, similar in spirit to [ideone.com](https://ideone.com/).

The code for this compiler can be found on [github](https://github.com/aweinert/coolc).

Major tools used: `Java`, `Eclipse`, `Maven`, `JUnit`, `travis`

# AutomataTutor
An online tool that helps students and instructors to teach and learn basic concepts in automata theory.
Provides automated feedback to the student if they provide a wrong automaton.
I rewrote the frontend of the tool, which is used by over **2000 students** from **12 continents** on **four continents**.

You can try it out [here](http://www.automatatutor.com).
Also, we [published](/assets/pdf/pub/2015/DWWA15.pdf) our experience in building, deploying and operating this tool in the Bulletin of the European Association for Theoretical Computer Science.

Major tools used: `Scala`, `Lift`, `sbt`, `SVN`

# AProVE
During my work on my Master's thesis at RWTH Aachen University I have contributed to the analysis of integer constraints in Prolog programs in [AproVE](http://aprove.informatik.rwth-aachen.de/), a powerful tool for proving termination of Java-, C- and Prolog-Programs.
On a set of benchmarks comprising 162 programs requiring such arithmetical analysis I was able to increase the power of the analysis from **67 programs** proven to be terminating to **110 programs** proven to be terminating.
Moreover, I decreased the runtime of the analysis from **55 seconds** in the mean and **71 seconds** in the median to around **14 seconds** in the mean and **2 seconds** in the median.

A complete presentation of the problem, my approach and an evaluation can be found in my [Master's thesis](/assets/pdf/pub/2015/W15a.pdf).

Major tools used: `Java`, `Eclipse`, `Git`

# InstRO
When I was a research assistant at the [Group for High Performance Computing](http://www.itc.rwth-aachen.de/cms/IT-Center/Forschung-Projekte/~eubj/High-Perfomance-Computing/lidx/1/) of the IT Center of RWTH Aachen University, [Christian Iwainsky](http://www.sc.informatik.tu-darmstadt.de/fg/people/christianiwainskydetails.en.jsp) and I started developing InstRO, a tool for instrumentation of C- and C++-code.

Christian has since moved on to [Darmstadt University](http://www.tu-darmstadt.de/), where the project is currently under development.
You can find the project page [here](http://www.sc.informatik.tu-darmstadt.de/res/sw/instro_main/index.de.jsp).

Major tools used: `C++`, `Make`, `SVN`
