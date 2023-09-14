# AssemblyBreakout
 This project showcases a classic arcade-style Breakout game implemented entirely in assembly language. Breakout is a timeless game that challenges players to break bricks using a paddle and ball.

# 1. Installation:

The was created using the MIPs architecture, therefore, you will need to use a MIPs IDE. I recomend using Saturn, link: https://github.com/1whatleytay/saturn. You can also use the MARS ide.

i. Clone the git repo

```
https://github.com/SheldonDacon/AssemblyBreakout.git
```

ii. Open project folder



# 5. How To Use:

i. Open project in preferred IDE. 

ii. Connect Keyboard and set The disaply configuration as indicated at the top of my assembly file.

iii. Click "run"  the game will pause for 3 seconds to give time to access the keyboard simulator, and will also pause for 3 seconds after the ball goes of the map.


# 6. How to play
- Control the paddle with your input method (arrow keys).
- Aim to break all the bricks while preventing the ball from falling off the screen. You have 5 lives
- Enjoy the challenge and have fun!
- press p to pause and q to quit
- A tallly of red block tracks your score
- Green blocks take 1 hit to break, yellow, 2 and red 3

# 7. Gmae features

The game has color changing bricks that chnage when you hit then, and has been optimised for the MIPs IDE to prevent crashes du to spamming inputs.
The physics system is a unique system that combines randomness into the movement of the brick to increase the difficulty. When you hit a wall you have a 60% chance of it going in the normal expected trajectory and a 40% chance of going in a random direction. Before the ball can move, its trajectory is saved in memory, it then checks if it can move to the space that it would move with its trajectory, if not, then it that means there a wall. It will then try to move to a space that it would move if it could bounce off the wall according to its trajectory. It then checks all other spaces that it can move. It then randomly chooses a direction to move



