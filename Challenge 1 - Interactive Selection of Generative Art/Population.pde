// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Interactive Selection
// http://www.genarts.com/karl/papers/siggraph91.html

// A class to describe a population of Figures
// this hasn't changed very much from example to example

class Population {

  float mutationRate;           // Mutation rate
  Figure[] population;            // array to hold the current population
  ArrayList<Figure> matingPool;   // ArrayList which we will use for our "mating pool"
  int generations;              // Number of generations

    // Create the population
  Population(float m, int num) {
    mutationRate = m;
    population = new Figure[num];
    matingPool = new ArrayList<Figure>(); //Instead   figure = new FractalRoot(frameCount);?
    generations = 0;
    for (int i = 0; i < population.length; i++) {
      population[i] = new Figure(new DNA(), 50+i*75, 60);
    }
  }

  // Display all Figures
  void display() {
    for (int i = 0; i < population.length; i++) {
      population[i].display();
    }
  }

  // Are we rolling over any of the Figures?
  void rollover(int mx, int my) {
    for (int i = 0; i < population.length; i++) {
      population[i].rollover(mx, my);
    }
  }

  // Generate a mating pool
  void selection() {
    // Clear the ArrayList
    matingPool.clear();

    // Calculate total fitness of whole population
    float maxFitness = getMaxFitness();

    // Calculate fitness for each member of the population (scaled to value between 0 and 1)
    // Based on fitness, each member will get added to the mating pool a certain number of times
    // A higher fitness = more entries to mating pool = more likely to be picked as a parent
    // A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    for (int i = 0; i < population.length; i++) {
      float fitnessNormal = map(population[i].getFitness(), 0, maxFitness, 0, 1);
      int n = (int) (fitnessNormal * 100);  // Arbitrary multiplier
      for (int j = 0; j < n; j++) {
        matingPool.add(population[i]);
      }
    }
  }  

  // Making the next generation
  void reproduction() {
    // Refill the population with children from the mating pool
    for (int i = 0; i < population.length; i++) {
      // Sping the wheel of fortune to pick two parents
      int m = int(random(matingPool.size()));
      int d = int(random(matingPool.size()));
      // Pick two parents
      Figure mom = matingPool.get(m);
      Figure dad = matingPool.get(d);
      // Get their genes
      DNA momgenes = mom.getDNA();
      DNA dadgenes = dad.getDNA();
      // Mate their genes
      DNA child = momgenes.crossover(dadgenes);
      // Mutate their genes
      child.mutate(mutationRate);
      // Fill the new population with the new child
      population[i] = new Figure(child, 50+i*75, 60);
    }
    generations++;
  }

  int getGenerations() {
    return generations;
  }

  // Find highest fintess for the population
  float getMaxFitness() {
    float record = 0;
    for (int i = 0; i < population.length; i++) {
      if (population[i].getFitness() > record) {
        record = population[i].getFitness();
      }
    }
    return record;
  }
}
