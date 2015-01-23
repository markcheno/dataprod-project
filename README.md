

This Shiny application implements a Monte Carlo trading system simulator. You select various inputs
describing a trading system and it then simulates many potential outcomes. Finally, it calculates and displays a number of useful statistics about the outcomes. It is useful to get a feel for how a particular trading system may perform in the future.

Inputs:

- How many simulations to run - more simulations will give more accurate statistics
- Number of plots to display - number of plots to sample and display from the entire simulation
- Percentage of winning trades - how often your system expects to make a winning trade
- Average winning trade in dollars
- Average losing trade in dollars
- Number of trades to simulate
- Starting equity - the amount of cash the account starts with

Outputs:

- Line plot of simulated equity curves - since we can't display thousands of plots at once, we only sample and display a subset from the full simulation
- Histogram of probable system ending value in dollars - the average ending value is plotted in blue
- Histogram of probable maximum drawdown in dollars - the average maxdd is plotted in blue
- Various other useful statistics - minimum,maximum,average,standard deviation,confidence intervales,expectancy

Interesting things to try:

- Set the average win and loss the same and then see how the winning percentage effects the equity
- Set the average win to three times the average loss and then vary the winning percentage
