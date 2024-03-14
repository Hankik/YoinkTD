interface Updates {

  abstract void update();
}

interface Displays {
  
  abstract void display();
}

@FunctionalInterface
interface Callback<T> {

  abstract T call();  
}
