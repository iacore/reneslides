# -------------------------------------------------------------
# GLOBALS
#

# the master defines fonts, bg imgs, colors, etc.
# bg pngs and fonts will reside in the same folder as the master sld
@master "assets/masters/nim/master.sld"   

# for slides without bg pngs:
@bgcolor f0d020

# global settings of the presentation
@title Artificial Voices In Human Choices
@subtitle AweSome
@author Dr. Carolin Kaiser, Rene Schallner
@date today - just some string if used
# -------------------------------------------------------------


# -------------------------------------------------------------
@slide type welcome
@title This is the title

@leftbox 
Here comes the left text.
- we have a bulleted list
    - we can indent
    - like so
- and back

@leftbox 
This box comes below the first one
This makes a continuation
_
We make empty lines with _.

@rightbox
this goes into the right box

@sources
if present, the sources come here
# -------------------------------------------------------------



# -------------------------------------------------------------
@slide 

@title this is the second slide

@singlebox
this is a single box layout
so no left and right, just one big one

@img "/path/to/image.png" tl 0.1 0.1 br 0.9 0.9 centerscale

@img "/path/to/image.png" tl 0.1 0.1 scale 0.9 0.9 

- we just placed an image and placed it 
- with relative TL BR coords, scaling to fit, centering the img
- with relative TL coords and x, y scale
# -------------------------------------------------------------



# -------------------------------------------------------------
@slide type thankyou

# nothing special, we could override author, subtitle, ...

# -------------------------------------------------------------
